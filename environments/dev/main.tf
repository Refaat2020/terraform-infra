module "network" {
  source = "../../modules/aws-vpc"
}

module "alb" {
  source = "../../modules/alb"
  vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}

module "ec2" {
  source = "../../modules/aws-ec2"
  vpc_id    = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids
alb_sg_id = module.alb.alb_sg_id
target_group_arn = module.alb.target_group_arn
}


