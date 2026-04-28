output "alb_dns" {
  value = aws_lb.app_lb.dns_name
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}


output "lb_arn_suffix" {
  value = aws_lb.app_lb.arn_suffix
}

output "tg_arn_suffix" {
  value = aws_lb_target_group.tg.arn_suffix
}

output "lb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "lb_zone_id" {
  value = aws_lb.app_lb.zone_id
}