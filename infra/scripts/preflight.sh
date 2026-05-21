#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

if [[ -f infra/.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source infra/.env
  set +a
fi

: "${AWS_REGION:?Set AWS_REGION}"
: "${EKS_CLUSTER_NAME:?Set EKS_CLUSTER_NAME}"
: "${RDS_INSTANCE_ID:?Set RDS_INSTANCE_ID}"
: "${DOCKERHUB_NAMESPACE:?Set DOCKERHUB_NAMESPACE}"

echo "Checking local tools..."
for command in aws eksctl kubectl helm docker; do
  command -v "${command}" >/dev/null || {
    echo "Missing required command: ${command}" >&2
    exit 1
  }
  echo "ok: ${command}"
done

echo
echo "Checking AWS identity..."
aws sts get-caller-identity --query 'Arn' --output text

echo
echo "Checking EKS cluster..."
if aws eks describe-cluster \
  --name "${EKS_CLUSTER_NAME}" \
  --region "${AWS_REGION}" \
  --query 'cluster.status' \
  --output text >/tmp/store-platform-eks-status 2>/dev/null; then
  echo "EKS ${EKS_CLUSTER_NAME}: $(cat /tmp/store-platform-eks-status)"
else
  echo "EKS ${EKS_CLUSTER_NAME}: not found yet"
fi
rm -f /tmp/store-platform-eks-status

echo
echo "Checking RDS instance..."
if aws rds describe-db-instances \
  --db-instance-identifier "${RDS_INSTANCE_ID}" \
  --region "${AWS_REGION}" \
  --query 'DBInstances[0].[DBInstanceStatus,Endpoint.Address]' \
  --output text >/tmp/store-platform-rds-status 2>/dev/null; then
  echo "RDS ${RDS_INSTANCE_ID}: $(cat /tmp/store-platform-rds-status)"
else
  echo "RDS ${RDS_INSTANCE_ID}: not found yet"
fi
rm -f /tmp/store-platform-rds-status

echo
echo "Preflight finished. No paid resource was created by this script."
