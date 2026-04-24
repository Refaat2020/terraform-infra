# output "nginx_container_id" {
#   description = "nginx container id"
#   value = module.nginx.container_id
# }


# output "nginx_container_name" {
#   description = "nginx Container name"
#   value = module.nginx.container_name
# }

output "instance_public_ip" {
  description = "EC2 public IP"
  value = module.ec2.instance_public_ip
}

output "alb_dns" {
  description = "EC2 public IP"
  value = module.alb.alb_dns
}