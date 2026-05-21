# Jenkins

## Objetivo

Preparar uma pipeline de CI/CD por microservico com build, publicacao de imagem e deploy em Kubernetes.

## Entregue

Cada servico do repositorio possui seu proprio `Jenkinsfile`:

- `account-service/Jenkinsfile`
- `auth-service/Jenkinsfile`
- `gateway-service/Jenkinsfile`
- `product-service/Jenkinsfile`
- `order-service/Jenkinsfile`
- `exchange/Jenkinsfile`

## Estagios padronizados

- `SCM`
- `Dependencies`
- `Build`
- `Push to Docker Hub`
- `Deploy to K8s`

## Artefatos de suporte

- `Dockerfile` por servico
- manifests Kubernetes por servico
- namespace compartilhado em `k8s/namespace.yaml`
- `compose.yaml` para validar a stack localmente antes do deploy

## Credenciais esperadas

- `dockerhub-credential`
- `kubeconfig`

## Variaveis esperadas

- `DOCKERHUB_NAMESPACE`

## Aderencia ao enunciado

- Os servicos pedidos literalmente em `Jenkins` estao presentes: `account-service`, `auth-service`, `gateway-service`, `product-service` e `order-service`.
- O repositorio tambem mantem `exchange-service`, implementado na etapa especifica de `Exchange API`, com pipeline propria para manter a stack completa versionada.
