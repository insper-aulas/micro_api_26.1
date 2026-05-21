#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

if [[ -f infra/.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source infra/.env
  set +a
fi

: "${DOCKERHUB_NAMESPACE:?Set DOCKERHUB_NAMESPACE}"
: "${K8S_NAMESPACE:=store-platform}"
: "${SERVICE_ROOT:=..}"
: "${DATABASE_HOST:=postgres}"
: "${RDS_DB_NAME:=store}"
: "${RDS_USERNAME:=store}"
: "${RDS_PASSWORD:=devpass}"

services=(
  "account-service:account-service"
  "auth-service:auth-service"
  "exchange:exchange-service"
  "gateway-service:gateway-service"
  "product-service:product-service"
  "order-service:order-service"
)

render_manifest() {
  local image="$1"
  local file="$2"

  sed \
    -e "s|namespace: store-platform|namespace: ${K8S_NAMESPACE}|g" \
    -e "s|IMAGE_PLACEHOLDER|${image}|g" \
    -e "s|DATABASE_HOST: postgres|DATABASE_HOST: ${DATABASE_HOST}|g" \
    -e "s|DATABASE_DB: store|DATABASE_DB: ${RDS_DB_NAME}|g" \
    -e "s|DATABASE_USERNAME: store|DATABASE_USERNAME: ${RDS_USERNAME}|g" \
    -e "s|DATABASE_PASSWORD: devpass|DATABASE_PASSWORD: ${RDS_PASSWORD}|g" \
    "${file}"
}

kubectl create namespace "${K8S_NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -
sed "s|namespace: store-platform|namespace: ${K8S_NAMESPACE}|g" infra/redis/deployment.yaml | kubectl apply -f -
sed "s|namespace: store-platform|namespace: ${K8S_NAMESPACE}|g" infra/redis/service.yaml | kubectl apply -f -

for service in "${services[@]}"; do
  service_dir="${service%%:*}"
  deployment_name="${service##*:}"
  manifest_dir="${SERVICE_ROOT}/${service_dir}/k8s"
  image="${DOCKERHUB_NAMESPACE}/${deployment_name}:latest"

  if [[ ! -d "${manifest_dir}" ]]; then
    echo "Missing manifest directory: ${manifest_dir}" >&2
    exit 1
  fi

  for manifest in "${manifest_dir}"/*.yaml; do
    render_manifest "${image}" "${manifest}" | kubectl apply -f -
  done
done

kubectl -n "${K8S_NAMESPACE}" rollout status deployment/gateway-service --timeout=180s || true
kubectl -n "${K8S_NAMESPACE}" get deploy,svc,hpa
