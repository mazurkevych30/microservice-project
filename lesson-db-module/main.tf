# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "14-07-2025-vladyslav-lesson-5"
  table_name  = "terraform-locks"
}

# Підключаємо модуль для VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson-5"
}

#Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-5-ecr"
  scan_on_push = true
}

module "eks" {
  source          = "./modules/eks"          
  cluster_name    = "eks-cluster-demo"            # Назва кластера
  subnet_ids      = module.vpc.public_subnets     # ID підмереж
  instance_type   = "t3.small"                    # Тип інстансів
  desired_size    = 2                             # Бажана кількість нодів
  max_size        = 4                            # Максимальна кількість нодів
  min_size        = 1                           # Мінімальна кількість нодів
}

locals {
  eks_cluster_name = module.eks.eks_cluster_name
}

data "aws_eks_cluster" "eks" {
  name = local.eks_cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name = local.eks_cluster_name
  depends_on = [module.eks]
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}


module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  
  providers = {
    helm = helm
    kubernetes = kubernetes
  }
}

module "argo_cd" {
  source       = "./modules/argo_cd"
  namespace    = "argocd"
  chart_version = "5.46.4"
}
