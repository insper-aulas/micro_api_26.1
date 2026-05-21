#!/usr/bin/env bash

set -euo pipefail

: "${DOCKERHUB_NAMESPACE:?Set DOCKERHUB_NAMESPACE}"

kubectl apply -f k8s/namespace.yaml
kubectl apply -f infra/redis

for service in account-service auth-service gateway-service product-service order-service; do
  kubectl -n store-platform set image "deployment/${service}" \
    "${service}=${DOCKERHUB_NAMESPACE}/${service}:latest" || true
done

kubectl -n store-platform set image deployment/exchange-service \
  "exchange-service=${DOCKERHUB_NAMESPACE}/exchange-service:latest" || true

kubectl -n store-platform get deploy,svc,hpa
