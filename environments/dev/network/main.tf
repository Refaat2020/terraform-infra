provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "../../../modules/aws-vpc"
  cidr_block           = var.cidr_block
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}