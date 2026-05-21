#!/usr/bin/env bash

set -euo pipefail

: "${EKS_CLUSTER_NAME:=store-platform}"
: "${AWS_REGION:=us-east-1}"

eksctl create cluster -f infra/eks/cluster.yaml

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  -f infra/eks/nginx-ingress-values.yaml

kubectl apply -f k8s/namespace.yaml
kubectl apply -f infra/redis
