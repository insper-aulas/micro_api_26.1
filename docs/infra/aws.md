# AWS

Esta parte ainda depende de uma conta AWS real. O repositorio ja deixa os scripts prontos para criar a infra, mas a validacao final precisa ser feita na conta do grupo.

## Checklist

- Criar ou usar um usuario IAM com acesso a EKS, EC2, CloudFormation, IAM, RDS e ELB.
- Criar access key para esse usuario.
- Instalar e configurar `aws`, `eksctl`, `kubectl` e `helm`.
- Preencher `infra/.env` a partir de `infra/.env.exemplo`.
- Criar o cluster EKS.
- Criar ou configurar o banco PostgreSQL.
- Publicar imagens no Docker Hub.
- Fazer deploy dos manifests no cluster.
- Salvar evidencias: prints do cluster, nodes, pods, services, ingress/load balancer, Jenkins e teste de carga.

## Passo a Passo

```bash
cd micro_api_26.1
cp infra/.env.exemplo infra/.env
```

Edite `infra/.env`:

```bash
AWS_REGION=us-east-1
EKS_CLUSTER_NAME=store-platform
DOCKERHUB_NAMESPACE=seu-usuario-dockerhub
RDS_PASSWORD=uma-senha-forte
```

Configure a CLI:

```bash
aws configure
aws sts get-caller-identity
```

Rode o preflight antes de criar recursos pagos:

```bash
infra/scripts/preflight.sh
```

Crie o EKS e o ingress controller:

```bash
infra/scripts/bootstrap.sh
```

Opcionalmente crie RDS:

```bash
infra/rds/create-instance.sh
```

Se usar RDS, copie o endpoint retornado para `DATABASE_HOST` em `infra/.env`. Se quiser demonstrar com banco dentro do cluster, mantenha `DATABASE_HOST=postgres`.

## Encerramento

Ao terminar a apresentacao ou validacao, destrua os recursos:

```bash
source infra/.env
infra/scripts/teardown.sh
```
