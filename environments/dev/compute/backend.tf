terraform {
  backend "s3" {
    bucket         = "terraform-state-refaat"
    key            = "dev/compute/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}