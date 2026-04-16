provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "nginx_sg" {
  name = "nginx-sg"

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
}