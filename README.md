# SHP1 --- Implementación de una infraestructura de red mediante Terraform

## 1. Introducción

Este proyecto implementa una infraestructura de red mediante
**Infraestructura como Código (IaC)**, utilizando Terraform para
declarar y administrar los recursos y Docker para ejecutar los servicios
en contenedores. La práctica forma parte de la asignatura
**Automatización de Infraestructura Digital II** y busca demostrar que
una infraestructura puede desplegarse, verificarse, destruirse y
reconstruirse de manera reproducible.

La solución se ejecuta en Kali Linux y no requiere contratar
infraestructura en la nube: los componentes se ejecutan localmente
mediante Docker.

## 2. Objetivos

### Objetivo general

Construir y automatizar una infraestructura de red privada con Terraform
y Docker, y comprobar su funcionamiento mediante scripts y evidencias de
ejecución.

### Objetivos específicos

-   Definir la red y los recursos mediante archivos de Terraform.
-   Asignar direcciones IP fijas a los servidores del laboratorio.
-   Desplegar un servidor web, un servidor de aplicaciones y un servidor
    de base de datos.
-   Automatizar el despliegue, la verificación y la eliminación de los
    recursos.
-   Comprobar la conectividad y la respuesta HTTP.
-   Validar la reproducibilidad mediante la destrucción y posterior
    reconstrucción de la infraestructura.
-   Mantener el código, los scripts, la documentación y las evidencias
    bajo control de versiones con Git.

## 3. Tecnologías utilizadas

-   **Kali Linux:** sistema operativo del entorno de laboratorio.
-   **Terraform:** herramienta de Infraestructura como Código para
    declarar y administrar los recursos.
-   **Docker:** ejecución aislada de los servicios en contenedores.
-   **Nginx (`nginx:alpine`):** servidor web.
-   **Python (`python:3.12-alpine`):** servicio de aplicaciones basado
    en `python -m http.server 8000`.
-   **PostgreSQL (`postgres:16-alpine`):** contenedor del servicio de
    base de datos.
-   **Bash:** automatización de tareas mediante scripts.
-   **Git y GitHub:** control de versiones y publicación del proyecto.

## 4. Arquitectura de la infraestructura

La infraestructura utiliza una red Docker de tipo `bridge` denominada
`red-privada`, con el rango `10.10.0.0/24` y gateway `10.10.0.1`.

``` text
                    Red privada Docker
                      10.10.0.0/24
                       Gateway .1
                            |
          +-----------------+-----------------+
          |                 |                 |
   +------+-------+  +------+-------+  +------+-------+
   | Servidor web |  | Servidor app  |  | Servidor DB  |
   | Nginx        |  | Python        |  | PostgreSQL   |
   | 10.10.0.10   |  | 10.10.0.20    |  | 10.10.0.30   |
   | Puerto 80    |  | Puerto 8000   |  | Puerto 5432  |
   +--------------+  +---------------+  +--------------+
```

### Componentes

  --------------------------------------------------------------------------------------
  Recurso        Nombre del       Imagen/tecnología      Dirección IP     Puerto
                 contenedor                                               
  -------------- ---------------- ---------------------- ---------------- --------------
  Red privada    `red-privada`    Docker bridge          `10.10.0.0/24`   ---

  Servidor web   `servidor-web`   `nginx:alpine`         `10.10.0.10`     `80` publicado
                                                                          en el host

  Servidor de    `servidor-app`   `python:3.12-alpine`   `10.10.0.20`     `8000`,
  aplicaciones                                                            interno

  Servidor de    `servidor-db`    `postgres:16-alpine`   `10.10.0.30`     `5432`,
  base de datos                                                           interno
  --------------------------------------------------------------------------------------

Los tres contenedores están conectados a la red privada y utilizan
direcciones IP fijas. El puerto 80 del servidor web se publica en el
equipo anfitrión, por lo que la URL de prueba es `http://localhost:80`.
Los puertos de la aplicación y de la base de datos no se publican al
anfitrión en la configuración descrita.

> **Alcance de la prueba:** la verificación de conectividad entre
> contenedores demuestra comunicación de red. Por sí sola no equivale a
> una prueba funcional de consultas a PostgreSQL ni a una integración de
> aplicación con base de datos.

## 5. Organización del repositorio

``` text
automatizacion-infraestructura/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── .terraform.lock.hcl
├── scripts/
│   ├── deploy.sh
│   ├── verify.sh
│   └── destroy.sh
├── docker/
│   └── docker-compose.yml
├── docs/
│   └── arquitectura.md
├── evidencias/
│   ├── 01-init.txt
│   ├── 02-validate.txt
│   ├── 03-plan.txt
│   ├── 04-apply.txt
│   ├── 05-show.txt
│   ├── 06-verify.txt
│   ├── 07-destroy.txt
│   ├── 08-reconstruccion.txt
│   └── 09-verify-final.txt
├── .gitignore
└── README.md
```

### Archivos de Terraform

-   **`main.tf`:** declara los recursos de Docker, incluida la red, las
    imágenes y los contenedores.
-   **`variables.tf`:** declara las variables utilizadas por la
    configuración.
-   **`terraform.tfvars`:** define los valores de las variables para el
    entorno local. Este archivo no debe publicarse si contiene
    contraseñas u otros datos sensibles.
-   **`outputs.tf`:** muestra información de salida, como las
    direcciones de los servidores y la URL del servidor web.
-   **`.terraform.lock.hcl`:** registra las versiones seleccionadas de
    los proveedores para favorecer instalaciones consistentes.

El despliegue probado administra siete recursos: una red Docker, tres
imágenes y tres contenedores.

## 6. Despliegue de la infraestructura

### Requisitos previos

Antes de ejecutar el proyecto, el equipo debe tener instalados Docker,
Terraform y Git. Docker debe estar iniciado y el usuario debe tener
permisos para utilizarlo.

### Despliegue automatizado

Desde la raíz del proyecto, ejecutar:

``` bash
cd ~/automatizacion-infraestructura
./scripts/deploy.sh
```

El script automatiza las operaciones de Terraform definidas en él,
incluyendo la inicialización, el formato, la validación, la
planificación y la aplicación de la configuración.

### Comandos manuales de referencia

Si se desea ejecutar las fases individualmente:

``` bash
terraform -chdir=terraform init
terraform -chdir=terraform fmt -check
terraform -chdir=terraform validate
terraform -chdir=terraform plan
terraform -chdir=terraform apply
terraform -chdir=terraform show
```

`plan` permite revisar los cambios propuestos antes de aplicarlos.
`apply` crea o actualiza los recursos de acuerdo con la configuración.

## 7. Verificación

Después del despliegue, ejecutar:

``` bash
./scripts/verify.sh
```

Las comprobaciones registradas incluyen:

-   Validación de la configuración de Terraform.
-   Inspección de los contenedores en ejecución mediante `docker ps`.
-   Comprobación de la existencia de la red Docker.
-   Pruebas de conectividad con las direcciones `10.10.0.10`,
    `10.10.0.20` y `10.10.0.30`.
-   Comprobación de comunicación de red entre el servidor web y el de
    aplicaciones, y entre el de aplicaciones y la base de datos.
-   Prueba HTTP al servidor web.

Para consultar manualmente el estado se pueden utilizar:

``` bash
docker ps
docker network ls
curl -I http://localhost
```

## 8. Destrucción y reconstrucción

Para eliminar los recursos administrados por Terraform, ejecutar:

``` bash
./scripts/destroy.sh
```

La ejecución registrada terminó con **7 recursos destruidos**. Después,
se ejecutó nuevamente `deploy.sh` y se creó otra vez la infraestructura.
La verificación final volvió a confirmar la conectividad y una respuesta
HTTP `200 OK`.

Este ciclo sirve como evidencia de que los recursos se pueden
reconstruir a partir de la configuración del proyecto. Antes de destruir
recursos, hay que asegurarse de que no contienen datos que se necesiten
conservar.

## 9. Resultados y evidencias

Los registros de las ejecuciones se guardan en `evidencias/`:

  -----------------------------------------------------------------------
  Archivo                             Evidencia
  ----------------------------------- -----------------------------------
  `01-init.txt`                       Inicialización de Terraform y
                                      proveedores

  `02-validate.txt`                   Validación de la configuración

  `03-plan.txt`                       Plan de cambios propuesto

  `04-apply.txt`                      Creación de recursos

  `05-show.txt`                       Estado y recursos administrados por
                                      Terraform

  `06-verify.txt`                     Primera verificación de
                                      infraestructura y servicios

  `07-destroy.txt`                    Eliminación de los recursos

  `08-reconstruccion.txt`             Despliegue posterior a la
                                      destrucción

  `09-verify-final.txt`               Verificación después de reconstruir
  -----------------------------------------------------------------------

Según los registros generados durante la práctica, Terraform validó la
configuración, se crearon los siete recursos previstos, las
comprobaciones de conectividad fueron satisfactorias y el servidor web
respondió con `HTTP 200 OK`. La destrucción y reconstrucción también se
completaron correctamente.

## 10. Infraestructura como Código y enfoque DevOps

El proyecto aplica principios de IaC al describir los recursos en
archivos versionables en lugar de depender exclusivamente de
configuraciones manuales. Los scripts permiten repetir tareas habituales
y ejecutar comprobaciones de forma consistente.

El uso de Git registra los cambios realizados en el proyecto, mientras
que GitHub facilita compartir el código y las evidencias. La combinación
de despliegue automatizado, verificación y reconstrucción ayuda a
detectar errores y a documentar el estado de la infraestructura.

## 11. Seguridad y mantenimiento

-   No publicar contraseñas, tokens ni otros secretos.
-   Mantener excluidos del repositorio los archivos de estado de
    Terraform, el directorio `.terraform/` y los planes locales.
-   Revisar `terraform.tfvars` antes de realizar commits.
-   No publicar puertos de servicios internos salvo que el diseño lo
    requiera.
-   Tener presente que los contenedores de laboratorio no sustituyen una
    configuración de producción con controles de acceso, persistencia,
    copias de seguridad y endurecimiento de seguridad.

## 12. Conclusiones

Se implementó una infraestructura de red privada con tres servicios en
contenedores, administrados mediante Terraform. Las pruebas registradas
verificaron las direcciones IP, la conectividad entre los contenedores y
la respuesta HTTP del servidor web. Además, la destrucción y la
reconstrucción de los recursos demostraron la reproducibilidad del
despliegue.

La práctica muestra cómo Terraform, Docker, Bash y Git pueden combinarse
para automatizar la creación, la comprobación y la documentación de una
infraestructura. Como mejora futura, se podría añadir una prueba de
aplicación que realice una operación real contra PostgreSQL, además de
las pruebas de conectividad de red.

## 13. Enlace al repositorio

**Repositorio GitHub:**\
https://github.com/brianleyva052-collab/Automatizacion-infraestructura
