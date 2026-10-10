#!/bin/bash
cd "$(dirname "$0")/../terraform"

echo "==> terraform validate"
terraform validate

echo -e "\n==> Contenedores en ejecución"
docker ps

echo -e "\n==> Redes Docker"
docker network ls

echo -e "\n==> Ping a los servidores"
for ip in 10.10.0.10 10.10.0.20 10.10.0.30; do
  ping -c 2 "$ip" > /dev/null && echo "OK   $ip" || echo "FALLO $ip"
done

echo -e "\n==> Comunicación entre servidores"
docker exec servidor-web ping -c 2 10.10.0.20 > /dev/null && echo "OK   web -> app" || echo "FALLO web -> app"
docker exec servidor-app ping -c 2 10.10.0.30 > /dev/null && echo "OK   app -> db"  || echo "FALLO app -> db"

echo -e "\n==> Servicio HTTP"
curl -sI http://localhost | head -n 1
