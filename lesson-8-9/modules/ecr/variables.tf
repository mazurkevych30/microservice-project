variable "ecr_name" {
  description = "Name of repository ECR"
  type        = string
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}
