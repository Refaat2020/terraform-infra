terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket = "terraform-state-refaat-dev"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
  
}