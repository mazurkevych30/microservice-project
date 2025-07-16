#s3
output "s3_bucket_name" {
  value       = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  value       = module.s3_backend.dynamodb_table_name
}

#vpc
output "vpc_id" {
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  value       = module.vpc.private_subnets
}

output "internet_gateway_id" {
  value       = module.vpc.internet_gateway_id
}

#ecr
output "repository_url" {
  value       = module.ecr.repository_url
}