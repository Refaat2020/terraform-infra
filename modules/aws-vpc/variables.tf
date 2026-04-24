variable "vpc_cidr" {
  description = "The Cidr block for the VC"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type = list(string)
  default = [ "10.0.1.0/24","10.0.2.0/24" ]
}

variable "private_subnet_cidrs" {
  description = "List Of CIDR blocks for private subnets"
  type = list(string)
  default = [ "10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_subnet_count" { 
    description = "number of private subnets to create"
    type = number
    default = 2
  
}

variable "public_subnet_count" {
   description = "number of public subnets to create"
    type = number
    default = 2
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}