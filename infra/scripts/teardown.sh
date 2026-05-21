#!/usr/bin/env bash

set -euo pipefail

: "${AWS_REGION:=us-east-1}"
: "${EKS_CLUSTER_NAME:=store-platform}"
: "${RDS_INSTANCE_ID:=store-platform-db}"

aws rds delete-db-instance \
  --region "${AWS_REGION}" \
  --db-instance-identifier "${RDS_INSTANCE_ID}" \
  --skip-final-snapshot || true

eksctl delete cluster --name "${EKS_CLUSTER_NAME}" --region "${AWS_REGION}"
