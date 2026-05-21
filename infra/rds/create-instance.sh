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
: "${RDS_INSTANCE_ID:?Set RDS_INSTANCE_ID}"
: "${RDS_DB_NAME:?Set RDS_DB_NAME}"
: "${RDS_USERNAME:?Set RDS_USERNAME}"
: "${RDS_PASSWORD:?Set RDS_PASSWORD}"

if aws rds describe-db-instances \
  --region "${AWS_REGION}" \
  --db-instance-identifier "${RDS_INSTANCE_ID}" >/dev/null 2>&1; then
  echo "RDS instance already exists: ${RDS_INSTANCE_ID}"
else
  aws rds create-db-instance \
    --region "${AWS_REGION}" \
    --db-instance-identifier "${RDS_INSTANCE_ID}" \
    --db-instance-class db.t3.micro \
    --engine postgres \
    --allocated-storage 20 \
    --master-username "${RDS_USERNAME}" \
    --master-user-password "${RDS_PASSWORD}" \
    --db-name "${RDS_DB_NAME}" \
    --publicly-accessible \
    --backup-retention-period 0
fi

aws rds wait db-instance-available \
  --region "${AWS_REGION}" \
  --db-instance-identifier "${RDS_INSTANCE_ID}"

endpoint="$(aws rds describe-db-instances \
  --region "${AWS_REGION}" \
  --db-instance-identifier "${RDS_INSTANCE_ID}" \
  --query 'DBInstances[0].Endpoint.Address' \
  --output text)"

echo "RDS endpoint ready: ${endpoint}"
echo "Set DATABASE_HOST=${endpoint} in infra/.env before running infra/scripts/deploy-all.sh if you want EKS to use RDS."
