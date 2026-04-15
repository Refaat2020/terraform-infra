module "nginx" {
  source = "../../modules/nginx"

  container_name = var.container_name
  external_port  = var.external_port
}