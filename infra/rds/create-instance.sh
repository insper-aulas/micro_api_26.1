#!/usr/bin/env bash

set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION}"
: "${RDS_INSTANCE_ID:?Set RDS_INSTANCE_ID}"
: "${RDS_DB_NAME:?Set RDS_DB_NAME}"
: "${RDS_USERNAME:?Set RDS_USERNAME}"
: "${RDS_PASSWORD:?Set RDS_PASSWORD}"

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

aws rds wait db-instance-available \
  --region "${AWS_REGION}" \
  --db-instance-identifier "${RDS_INSTANCE_ID}"
