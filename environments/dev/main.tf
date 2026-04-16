module "network" {
  source = "../../modules/aws-vpc"
}

module "ec2" {
  source = "../../modules/aws-ec2"

  subnet_id = module.network.subnet_id
  vpc_id    = module.network.vpc_id

}