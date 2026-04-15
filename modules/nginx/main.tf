terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.2.0"
    }
  }
}


resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
    name = var.container_name
    image = docker_image.nginx.image_id
    ports{
        internal = 80
        external = var.external_port
    }
}



