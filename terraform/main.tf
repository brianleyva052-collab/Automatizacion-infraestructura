terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# ---------- Red ----------
resource "docker_network" "lab" {
  name   = var.network_name
  driver = "bridge"

  ipam_config {
    subnet  = var.network_cidr
    gateway = var.gateway_ip
  }
}

# ---------- Imágenes ----------
resource "docker_image" "web" {
  name         = var.web_image
  keep_locally = true
}

resource "docker_image" "app" {
  name         = var.app_image
  keep_locally = true
}

resource "docker_image" "db" {
  name         = var.db_image
  keep_locally = true
}

# ---------- Servidor DB ----------
resource "docker_container" "db" {
  name  = "servidor-db"
  image = docker_image.db.image_id
  env   = ["POSTGRES_PASSWORD=${var.db_password}"]

  networks_advanced {
    name         = docker_network.lab.name
    ipv4_address = var.db_ip
  }
}

# ---------- Servidor de aplicaciones ----------
resource "docker_container" "app" {
  name    = "servidor-app"
  image   = docker_image.app.image_id
  command = ["python", "-m", "http.server", "8000"]

  networks_advanced {
    name         = docker_network.lab.name
    ipv4_address = var.app_ip
  }

  depends_on = [docker_container.db]
}

# ---------- Servidor web ----------
resource "docker_container" "web" {
  name  = "servidor-web"
  image = docker_image.web.image_id

  ports {
    internal = 80
    external = var.web_external_port
  }

  networks_advanced {
    name         = docker_network.lab.name
    ipv4_address = var.web_ip
  }

  depends_on = [docker_container.app]
}
