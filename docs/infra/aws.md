# AWS

O projeto foi preparado para execucao em AWS usando EKS, Load Balancer, banco PostgreSQL e imagens publicadas em registry externo. A conta AWS do grupo foi usada como infraestrutura compartilhada da entrega.

## Evidencia registrada

- Regiao visualizada no console: `US East (N. Virginia)` / `us-east-1`.
- O painel de custo e uso da conta AWS mostra consumo ativo no mes, incluindo custos associados a `Elastic Container Service for Kubernetes`, `Relational Database Service`, `EC2 - Other`, `MQ`, impostos e outros itens.
- Custo observado no console: `US$ 385,40` no mes atual.
- Previsao exibida pelo console: `US$ 393,13` para o final do mes.

O print correspondente deve ser salvo em `docs/evidence/screenshots/aws-cost-and-usage.png` antes da entrega final, se o grupo quiser anexar a evidencia visual dentro do repositorio.

## Checklist

- Usuario IAM com acesso a EKS, EC2, CloudFormation, IAM, RDS e ELB.
- CLI `aws`, `eksctl`, `kubectl` e `helm` configuradas.
- Cluster EKS e recursos associados provisionados para a demonstracao.
- Custo real observado no console AWS.
- Evidencias finais a anexar: cluster, nodes, pods, services, ingress/load balancer, Jenkins e teste de carga.

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
