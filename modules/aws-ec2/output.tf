output "asg_name" {
  value = aws_autoscaling_group.nginx_asg.name
}

output "asg_arn" {
  value = aws_autoscaling_group.nginx_asg.arn
}