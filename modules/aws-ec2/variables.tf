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

variable "image_id" {
  type = string
  description = "instance image id"
  default = "ami-098e39bafa7e7303d"
}

variable "alb_sg_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}