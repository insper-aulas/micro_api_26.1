# EKS

The EKS cluster definition lives in `infra/eks/cluster.yaml`.

## Bootstrap Flow

```bash
cp infra/.env.exemplo infra/.env
source infra/.env
infra/scripts/bootstrap.sh
```

The bootstrap script creates the cluster, installs nginx ingress and applies the shared namespace.
