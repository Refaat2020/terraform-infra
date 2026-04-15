output "container_id" {
  description = "ID of the running container"
  value = docker_container.nginx.id
}


output "container_name" {
  description = "Name of the running container"
  value = docker_container.nginx.name
}