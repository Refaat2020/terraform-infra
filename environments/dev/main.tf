# module "nginx" {
#   source = "../../modules/nginx"

#   container_name = var.container_name
#   external_port  = var.external_port
# }


module "ec2" {
  source = "../../modules/aws-ec2"
}