# Infrastructure

This folder contains the production-oriented infrastructure outline used for the final delivery.

## Contents

- `eks/cluster.yaml`: EKS cluster definition for `eksctl`.
- `rds/create-instance.sh`: RDS PostgreSQL creation helper.
- `rds/schema-init.md`: schema notes for the services.
- `redis/`: Redis manifests for Kubernetes.
- `scripts/`: bootstrap, deploy and teardown helpers.

## Usage

```bash
cp infra/.env.exemplo infra/.env
source infra/.env
infra/scripts/bootstrap.sh
infra/rds/create-instance.sh
infra/scripts/deploy-all.sh
```

The scripts are intentionally small and explicit so they can be reviewed before running in a paid cloud account.

## Where to create `.env`

Create the real `.env` inside this `infra/` folder:

```text
micro_api_26.1/
  infra/
    .env.exemplo
    .env
```

Do not create it in the workspace root or inside each service repository.
The `.env` file is ignored by Git because it contains real credentials and cloud configuration.
