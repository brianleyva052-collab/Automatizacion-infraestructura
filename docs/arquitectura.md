# Documentación de la arquitectura

## Diseño de red

La infraestructura utiliza una red privada Docker de tipo bridge con el rango `10.10.0.0/24` y gateway `10.10.0.1`.

## Componentes

| Componente 		   | Nombre 	    | Dirección IP   | Función 				     |
|--------------------------|----------------|----------------|---------------------------------------|
| Red Docker 		   | `red-privada`  | `10.10.0.0/24` | Comunicación interna 		     |
| Servidor web 		   | `servidor-web` | `10.10.0.10`   | Publicación HTTP mediante Nginx       |
| Servidor de aplicaciones | `servidor-app` | `10.10.0.20`   | Servicio Python en el puerto 8000     |
| Base de datos 	   | `servidor-db`  | `10.10.0.30`   | Servicio PostgreSQL en el puerto 5432 |

## Comunicación

Los tres contenedores se conectan a la misma red privada. Las pruebas automatizadas comprobaron la conectividad con las tres direcciones IP, la comunicación entre web y aplicación y entre aplicación y base de datos.

El servidor web publica el puerto 80 del contenedor en el equipo anfitrión.

## Administración con Terraform

Terraform administra la red, las imágenes y los contenedores. La configuración se organiza en los archivos `main.tf`, `variables.tf`, `terraform.tfvars` y `outputs.tf`.

## Flujo de trabajo

1. Inicializar Terraform.
2. Formatear y validar los archivos.
3. Revisar el plan de ejecución.
4. Crear la infraestructura.
5. Ejecutar las pruebas de verificación.
6. Destruir los recursos cuando sea necesario.
7. Volver a desplegar y verificar la reproducibilidad.
