terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-s3-state"
    key = "auto-deploy/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
    
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.18.0"
    }
  }
}