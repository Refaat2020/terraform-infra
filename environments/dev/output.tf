output "alb_dns" {
  description = "EC2 public IP"
  value = module.alb.alb_dns
}