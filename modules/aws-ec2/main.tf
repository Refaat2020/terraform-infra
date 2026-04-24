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

resource "aws_instance" "nginx" {
  ami = "ami-098e39bafa7e7303d"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data = <<-EOF
                #!/bin/bash
                dnf update -y
                dnf install -y nginx
                systemctl start nginx
                systemctl enable nginx
                EOF
  tags = {
    Name = "terraform-nginx"
  }
  subnet_id = var.private_subnet_ids[0]
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
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