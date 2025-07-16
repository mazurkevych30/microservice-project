terraform {
  backend "s3" {
    bucket         = "14-07-2025-vladyslav-lesson-5"
    key            = "lesson-5/terraform.tfstate"  
    region         = "eu-central-1"                  
    dynamodb_table = "terraform-locks"              
    encrypt        = true                           
  }
}

