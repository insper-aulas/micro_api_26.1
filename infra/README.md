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
infra/scripts/preflight.sh
infra/scripts/bootstrap.sh
infra/rds/create-instance.sh
infra/scripts/deploy-all.sh
```

The scripts are intentionally small and explicit so they can be reviewed before running in a paid cloud account.

`preflight.sh` only validates tools and AWS access. `bootstrap.sh` creates the EKS cluster and ingress controller. `create-instance.sh` creates or reuses the RDS instance and prints the endpoint. If the application should use RDS, copy that endpoint into `DATABASE_HOST` in `infra/.env` before running `deploy-all.sh`.

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
