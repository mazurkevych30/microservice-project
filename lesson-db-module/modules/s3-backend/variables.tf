variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
  default = "14-07-2025-vladyslav-lesson-5"
}

variable "table_name" {
  description = "The name of the DynamoDB table for Terraform locks"
  type        = string
  default = "terraform-locks"
}

