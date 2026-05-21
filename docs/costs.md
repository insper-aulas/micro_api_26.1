# Costs

The cloud setup should be treated as temporary infrastructure for demonstration.

## Main Cost Drivers

- EKS control plane.
- EC2 nodes.
- RDS PostgreSQL.
- Load balancer.

## Cleanup

```bash
source infra/.env
infra/scripts/teardown.sh
```
