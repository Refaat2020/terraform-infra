variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
  description = "VPC ID where resources will be created"

}

variable "alb_sg_id" {
  type = string
}