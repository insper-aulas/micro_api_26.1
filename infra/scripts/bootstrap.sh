#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

if [[ -f infra/.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source infra/.env
  set +a
fi

: "${EKS_CLUSTER_NAME:=store-platform}"
: "${AWS_REGION:=us-east-1}"
: "${EKS_VERSION:=1.30}"
: "${EKS_NODE_INSTANCE_TYPE:=t3.small}"
: "${EKS_NODE_DESIRED_CAPACITY:=2}"
: "${EKS_NODE_MIN_SIZE:=1}"
: "${EKS_NODE_MAX_SIZE:=4}"
: "${EKS_NODE_VOLUME_SIZE:=20}"
: "${K8S_NAMESPACE:=store-platform}"

for command in aws eksctl kubectl helm; do
  command -v "${command}" >/dev/null || {
    echo "Missing required command: ${command}" >&2
    exit 1
  }
done

cluster_config="$(mktemp)"
trap 'rm -f "${cluster_config}"' EXIT

sed \
  -e "s|\${EKS_CLUSTER_NAME}|${EKS_CLUSTER_NAME}|g" \
  -e "s|\${AWS_REGION}|${AWS_REGION}|g" \
  -e "s|\${EKS_VERSION}|${EKS_VERSION}|g" \
  -e "s|\${EKS_NODE_INSTANCE_TYPE}|${EKS_NODE_INSTANCE_TYPE}|g" \
  -e "s|\${EKS_NODE_DESIRED_CAPACITY}|${EKS_NODE_DESIRED_CAPACITY}|g" \
  -e "s|\${EKS_NODE_MIN_SIZE}|${EKS_NODE_MIN_SIZE}|g" \
  -e "s|\${EKS_NODE_MAX_SIZE}|${EKS_NODE_MAX_SIZE}|g" \
  -e "s|\${EKS_NODE_VOLUME_SIZE}|${EKS_NODE_VOLUME_SIZE}|g" \
  infra/eks/cluster.yaml > "${cluster_config}"

eksctl create cluster -f "${cluster_config}"

aws eks update-kubeconfig \
  --name "${EKS_CLUSTER_NAME}" \
  --region "${AWS_REGION}"

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  -f infra/eks/nginx-ingress-values.yaml

kubectl create namespace "${K8S_NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -
sed "s|namespace: store-platform|namespace: ${K8S_NAMESPACE}|g" infra/redis/deployment.yaml | kubectl apply -f -
sed "s|namespace: store-platform|namespace: ${K8S_NAMESPACE}|g" infra/redis/service.yaml | kubectl apply -f -
