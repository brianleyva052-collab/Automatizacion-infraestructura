output "network_id" {
  description = "ID de la red creada"
  value       = docker_network.lab.id
}

output "web_ip" {
  value = var.web_ip
}

output "app_ip" {
  value = var.app_ip
}

output "db_ip" {
  value = var.db_ip
}

output "web_url" {
  value = "http://localhost:${var.web_external_port}"
}
