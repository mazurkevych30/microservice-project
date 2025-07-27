resource "aws_ecr_repository" "this" {
  name = var.ecr_name
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = var.ecr_name
  }
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid    = "AllowPushPull",
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  })
}