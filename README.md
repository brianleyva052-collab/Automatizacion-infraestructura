# SHP1: Implementación de una infraestructura de red mediante Terraform

## 1. Introducción

Este proyecto consiste en construir y automatizar una infraestructura de red mediante Infraestructura como Código (IaC), utilizando Terraform y Docker. La infraestructura está formada por una red privada y tres servidores virtualizados mediante contenedores: web, aplicaciones y base de datos.

## 2. Objetivo

Implementar una infraestructura reproducible, administrar sus recursos mediante código y verificar su funcionamiento mediante scripts automatizados.

## 3. Herramientas utilizadas

- Kali Linux.
- Terraform.
- Docker.
- Git.
- Bash.
- Nginx para el servidor web.
- Python para el servidor de aplicaciones.
- PostgreSQL para la base de datos.

## 4. Arquitectura

La infraestructura utiliza una red Docker de tipo bridge con el rango `10.10.0.0/24`.

| Recurso	 	    | Nombre 	     | Dirección IP   | Servicio 		|
|---------------------------|----------------|----------------|-------------------------|
| Red privada 	 	    | `red-privada`  | `10.10.0.0/24` | Comunicación interna 	|
| Servidor web   	    | `servidor-web` | `10.10.0.10`   | HTTP, puerto 80 	|
| Servidor de aplicaciones  | `servidor-app` | `10.10.0.20`   | Python, puerto 8000 	|
| Servidor de base de datos | `servidor-db`  | `10.10.0.30`   | PostgreSQL, puerto 5432 |

El servidor web publica el puerto 80 en el equipo anfitrión. Los puertos de la aplicación y de la base de datos permanecen internos a la red Docker.

## 5. Implementación con Terraform

Los archivos Terraform definen la red, las imágenes y los contenedores.

- `main.tf`: definición de los recursos de infraestructura.
- `variables.tf`: declaración de variables.
- `terraform.tfvars`: valores utilizados para configurar la infraestructura.
- `outputs.tf`: datos de salida, como las direcciones IP y la URL del servidor web.

Para inicializar y validar el proyecto se utilizan los siguientes comandos:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform show
```

El comando `terraform apply` crea los recursos definidos en el código.

## 6. Automatización mediante scripts

- `scripts/deploy.sh`: automatiza la inicialización, validación y despliegue.
- `scripts/verify.sh`: comprueba el estado de la infraestructura, la conectividad entre servidores y la respuesta HTTP.
- `scripts/destroy.sh`: elimina los recursos administrados por Terraform.

Estos scripts simplifican la ejecución de las tareas y reducen la necesidad de introducir manualmente cada comando.

## 7. Procedimiento de despliegue

Desde el directorio del proyecto, se ejecuta:

```bash
./scripts/deploy.sh
```

Después, se verifica el funcionamiento:

```bash
./scripts/verify.sh
```

Para consultar los recursos creados se pueden utilizar:

```bash
terraform show
docker ps
docker network ls
```

## 8. Resultados y pruebas

Durante las pruebas realizadas:

- Terraform validó correctamente la configuración.
- Se crearon siete recursos: una red Docker, tres imágenes y tres contenedores.
- Los servidores recibieron las direcciones IP configuradas.
- Las comprobaciones de conectividad a las tres direcciones IP fueron satisfactorias.
- Las pruebas de comunicación entre web y aplicación, y entre aplicación y base de datos, fueron satisfactorias.
- El servidor web respondió con el código HTTP `200 OK`.
- La destrucción eliminó los siete recursos administrados por Terraform.
- La reconstrucción volvió a crear los recursos y la verificación final fue satisfactoria.

Las evidencias de ejecución se encuentran en el directorio `evidencias/`.

## 9. Reproducibilidad e Infraestructura como Código

La infraestructura se define mediante archivos de configuración y no depende exclusivamente de pasos manuales. La prueba de destrucción y reconstrucción permitió comprobar que Terraform puede volver a crear los recursos a partir del código del proyecto.

## 10. Conclusiones

La práctica permitió implementar una infraestructura de red privada con tres servicios separados mediante Docker y administrados con Terraform. 
Las pruebas de conectividad y HTTP confirmaron el funcionamiento de los servicios, mientras que la destrucción y reconstrucción demostraron la reproducibilidad de la infraestructura.

El uso de Infraestructura como Código facilita la administración, la repetición de despliegues y el mantenimiento de configuraciones consistentes.
