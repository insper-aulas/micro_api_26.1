# AWS

The production option uses AWS as the IaaS layer.

## Components

- EKS for Kubernetes workloads.
- RDS PostgreSQL for persistent data.
- Load Balancer created by nginx ingress.
- Redis deployed inside Kubernetes for cache.

## Cost Control

The provided scripts use small instances and include a teardown helper. Review the resources before running them in a real AWS account.
