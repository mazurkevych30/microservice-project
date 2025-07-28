# Створюємо DynamoDB-таблицю для блокування стейтів
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PROVISIONED"
  read_capacity = 1
  write_capacity = 1
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "lesson-5"
  }
}

