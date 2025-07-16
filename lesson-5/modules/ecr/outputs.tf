output "repository_url" {
  description = "URL repository ECR"
  value       = aws_ecr_repository.this.repository_url
}
