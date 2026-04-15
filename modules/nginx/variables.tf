variable "container_name" {
  description = "Name of the Docker Container"
  type = string
}


variable "external_port" {
 description = "Port Exposed on 8080"
 type = number
 default = 8080
}