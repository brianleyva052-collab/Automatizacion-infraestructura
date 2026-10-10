#!/bin/bash
set -e
cd "$(dirname "$0")/../terraform"

echo "==> terraform init";     terraform init
echo "==> terraform fmt";      terraform fmt
echo "==> terraform validate"; terraform validate
echo "==> terraform plan";     terraform plan -out=tfplan
echo "==> terraform apply";    terraform apply -auto-approve tfplan
echo "==> Despliegue completado"
