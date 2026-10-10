variable "network_name" {
  description = "Nombre de la red Docker"
  type        = string
  default     = "red-privada"
}

variable "network_cidr" {
  description = "CIDR de la red"
  type        = string
  default     = "10.10.0.0/24"
}

variable "gateway_ip" {
  description = "Gateway de la red"
  type        = string
  default     = "10.10.0.1"
}

variable "web_ip" {
  description = "IP del servidor web"
  type        = string
  default     = "10.10.0.10"
}

variable "app_ip" {
  description = "IP del servidor de aplicaciones"
  type        = string
  default     = "10.10.0.20"
}

variable "db_ip" {
  description = "IP del servidor de base de datos"
  type        = string
  default     = "10.10.0.30"
}

variable "web_image" {
  description = "Imagen del servidor web"
  type        = string
  default     = "nginx:alpine"
}

variable "app_image" {
  description = "Imagen del servidor de aplicaciones"
  type        = string
  default     = "python:3.12-alpine"
}

variable "db_image" {
  description = "Imagen del servidor de base de datos"
  type        = string
  default     = "postgres:16-alpine"
}

variable "web_external_port" {
  description = "Puerto del host para acceder al servidor web"
  type        = number
  default     = 80
}

variable "db_password" {
  description = "Contraseña de PostgreSQL (solo laboratorio)"
  type        = string
  sensitive   = true
}
