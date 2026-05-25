# CI/CD

Cada servico tem seu proprio `Jenkinsfile`.

## Estagios

- `SCM`
- `Dependencies`
- `Build`
- `Push to Docker Hub`
- `Deploy to K8s`

## Jenkins

O Jenkins local fica em `jenkins/compose.yaml`.

Credenciais esperadas:

- `dockerhub-credential`
- `kubeconfig`

Variavel esperada:

- `DOCKERHUB_NAMESPACE`

## Como Fechar a Entrega

1. Crie o cluster EKS e rode `aws eks update-kubeconfig`.
2. No Jenkins, cadastre `dockerhub-credential` como usuario/senha ou token do Docker Hub.
3. Cadastre `kubeconfig` como arquivo, usando o kubeconfig que aponta para o EKS.
4. Configure `DOCKERHUB_NAMESPACE` no ambiente do Jenkins.
5. Rode o pipeline de cada servico.
6. Valide que cada pipeline terminou em `Deploy to K8s`.
7. Confirme no cluster:

```bash
kubectl -n store-platform get deploy,svc,hpa,ingress
kubectl -n store-platform rollout status deployment/gateway-service
```

Evidencia esperada: print do Jenkins com build verde, imagem publicada no Docker Hub e pods atualizados no EKS.
