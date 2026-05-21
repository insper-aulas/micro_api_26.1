# MiniKube

## Objetivo

Executar os microservicos no mesmo cluster Kubernetes local, com manifests completos e verificacao de saude.

## Entregue

Cada microservico possui manifests Kubernetes separados por responsabilidade:

- `Secret`
- `ConfigMap`
- `Deployment`
- `Service`
- `HorizontalPodAutoscaler` nos servicos com escala horizontal

Arquivos:

- `account-service/k8s/*.yaml`
- `auth-service/k8s/*.yaml`
- `gateway-service/k8s/*.yaml`
- `product-service/k8s/*.yaml`
- `order-service/k8s/*.yaml`
- `exchange/k8s/*.yaml`
- `k8s/namespace.yaml`
- `k8s/postgres/*.yaml`
- `k8s/redis/*.yaml`

## Scripts de apoio

- `scripts/k8s/deploy-local-cluster.sh`
- `scripts/k8s/check-health.sh`
- `scripts/k8s/kind-config.yaml`
- `scripts/k8s/install-kind.sh`

## Exemplo com `kind`

```bash
./scripts/k8s/install-kind.sh
./scripts/k8s/bin/kind create cluster --name store --config scripts/k8s/kind-config.yaml
./scripts/k8s/deploy-local-cluster.sh
./scripts/k8s/check-health.sh
```

## Validacao executada

O fluxo acima foi executado localmente em `2026-05-14`, com seis `Deployment` em estado `Running` e o script `check-health.sh` concluindo com sucesso.

## O que o deploy faz

- builda as seis imagens locais
- carrega as imagens no cluster `kind` quando aplicavel
- aplica namespace, Postgres, Redis e manifests dos servicos
- espera o rollout dos oito `Deployment`
- lista `pods` e `services` ao final

## Aderencia ao enunciado

- Os servicos pedidos literalmente em `MiniKube` estao presentes: `account-service`, `auth-service`, `gateway-service`, `product-service` e `order-service`.
- O repositorio tambem publica `exchange-service` no mesmo cluster para manter a stack completa utilizada nas etapas anteriores.
