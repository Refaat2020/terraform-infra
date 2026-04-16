variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type = list(string)
}

variable "vpc_id" {
  type = string
  description = "VPC ID where resources will be created"

}