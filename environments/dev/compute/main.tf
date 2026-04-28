provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "terraform-state-refaat"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "dns" {
  backend = "s3"

  config = {
    bucket = "terraform-state-refaat"
    key    = "dev/dns/terraform.tfstate"
    region = "us-east-1"
  }
}



module "alb" {
  source = "../../../modules/alb"

  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.network.outputs.public_subnets

  certificate_arn = data.terraform_remote_state.dns.outputs.certificate_arn
}


module "ec2" {
  source = "../../../modules/aws-ec2"

  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnets

  alb_sg_id        = module.alb.alb_sg_id
  target_group_arn = module.alb.target_group_arn

  instance_type = var.instance_type
    resource_label = "${module.alb.lb_arn_suffix}/${module.alb.tg_arn_suffix}"
}


resource "aws_route53_record" "app" {
  zone_id = data.terraform_remote_state.dns.outputs.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}