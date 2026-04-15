terraform {
  backend "s3" {
    bucket = "terraform-state-refaat-dev"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}