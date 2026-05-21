#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NAMESPACE="${NAMESPACE:-store-platform}"
COOKIE_JAR="/tmp/store-gateway-cookies.txt"
PORT_FORWARD_PIDS=()

cleanup() {
  for pid in "${PORT_FORWARD_PIDS[@]}"; do
    kill "${pid}" >/dev/null 2>&1 || true
  done
  for pid in "${PORT_FORWARD_PIDS[@]}"; do
    wait "${pid}" 2>/dev/null || true
  done
  rm -f "${COOKIE_JAR}" >/dev/null 2>&1 || true
}

wait_for_port() {
  local port="$1"
  for _ in $(seq 1 30); do
    if nc -z 127.0.0.1 "${port}" >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  return 1
}

trap cleanup EXIT

kubectl -n "${NAMESPACE}" port-forward service/account-service 18083:8083 >/tmp/account-port-forward.log 2>&1 &
PORT_FORWARD_PIDS+=("$!")
kubectl -n "${NAMESPACE}" port-forward service/auth-service 18084:8084 >/tmp/auth-port-forward.log 2>&1 &
PORT_FORWARD_PIDS+=("$!")
kubectl -n "${NAMESPACE}" port-forward service/gateway-service 18085:8085 >/tmp/gateway-port-forward.log 2>&1 &
PORT_FORWARD_PIDS+=("$!")
kubectl -n "${NAMESPACE}" port-forward service/product-service 18080:8080 >/tmp/product-port-forward.log 2>&1 &
PORT_FORWARD_PIDS+=("$!")
kubectl -n "${NAMESPACE}" port-forward service/order-service 18081:8081 >/tmp/order-port-forward.log 2>&1 &
PORT_FORWARD_PIDS+=("$!")
kubectl -n "${NAMESPACE}" port-forward service/exchange-service 18000:8000 >/tmp/exchange-port-forward.log 2>&1 &
PORT_FORWARD_PIDS+=("$!")

wait_for_port 18083
wait_for_port 18084
wait_for_port 18085
wait_for_port 18080
wait_for_port 18081
wait_for_port 18000

curl --fail --silent http://127.0.0.1:18083/ >/dev/null
curl --fail --silent http://127.0.0.1:18084/auth/ >/dev/null
curl --fail --silent http://127.0.0.1:18085/ >/dev/null
curl --fail --silent http://127.0.0.1:18080/ >/dev/null
curl --fail --silent http://127.0.0.1:18081/ >/dev/null
curl --fail --silent http://127.0.0.1:18000/ >/dev/null

EMAIL="integration.$(date +%s)@example.com"
PASSWORD="securepass"

curl --fail --silent \
  -X POST http://127.0.0.1:18085/auth/register \
  -H 'Content-Type: application/json' \
  -d "{\"name\":\"Integration User\",\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\"}" >/dev/null

curl --fail --silent \
  -c "${COOKIE_JAR}" \
  -X POST http://127.0.0.1:18085/auth/login \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\"}" >/dev/null

PRODUCT_RESPONSE="$(
  curl --fail --silent \
    -b "${COOKIE_JAR}" \
    -X POST http://127.0.0.1:18085/products \
    -H 'Content-Type: application/json' \
    -d '{"name":"Gateway Tomato","price":10.12,"unit":"kg"}'
)"

PRODUCT_ID="$(printf '%s' "${PRODUCT_RESPONSE}" | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')"

ORDER_RESPONSE="$(
  curl --fail --silent \
    -b "${COOKIE_JAR}" \
    -X POST http://127.0.0.1:18085/orders \
    -H 'Content-Type: application/json' \
    -d "{\"items\":[{\"idProduct\":\"${PRODUCT_ID}\",\"quantity\":2}]}"
)"

ORDER_ID="$(printf '%s' "${ORDER_RESPONSE}" | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')"

curl --fail --silent -b "${COOKIE_JAR}" http://127.0.0.1:18085/products >/dev/null
curl --fail --silent -b "${COOKIE_JAR}" http://127.0.0.1:18085/orders >/dev/null
curl --fail --silent -b "${COOKIE_JAR}" "http://127.0.0.1:18085/orders/${ORDER_ID}?currency=BRL" >/dev/null
curl --fail --silent -b "${COOKIE_JAR}" http://127.0.0.1:18085/exchanges/USD/BRL >/dev/null

echo "All services and the gateway flow responded successfully."
