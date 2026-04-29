provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "nginx_sg" {
  name = "nginx-sg"

  ingress {
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  security_groups = [var.alb_sg_id]
}


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
}



resource "aws_iam_role" "ssm_role" {
  name = "ec2-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssn" {
    role       = aws_iam_role.ssm_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ssm_role.name
}



resource "aws_launch_template" "nginx" {
  name_prefix = "nginx-template"
  image_id = var.image_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }  

  vpc_security_group_ids = [ aws_security_group.nginx_sg.id ]
  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl daemon-reexec
              systemctl enable nginx
              systemctl start nginx
              EOF
  )
}

resource "aws_autoscaling_group" "nginx_asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.nginx.id
    version = aws_launch_template.nginx.latest_version
  }

  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120
  lifecycle {

      ignore_changes = [desired_capacity]

    }
  tag {
    key                 = "Name"
    value               = "nginx-asg"
    propagate_at_launch = true
  }
}


# resource "aws_autoscaling_policy" "cpu_target" {
#   name = "cpu-target-tracking"
#   autoscaling_group_name = aws_autoscaling_group.nginx_asg.name

#   policy_type = "TargetTrackingScaling"

#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#     target_value = 50.0
#   }
# }


resource "aws_autoscaling_policy" "alb_request" {
  name = "alb-requests-scaling"
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.name
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = var.resource_label
    }
    target_value = 50
  }
}