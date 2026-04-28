provider "aws" {
  region = "us-east-1"
}

module "dns" {
  source      = "../../../modules/dns"
  domain_name = var.domain_name
}

module "acm" {
  source      = "../../../modules/acm"
  domain_name = var.domain_name
  zone_id     = module.dns.zone_id
}