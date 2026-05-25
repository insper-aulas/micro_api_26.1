# EKS

A definicao do cluster fica em `infra/eks/cluster.yaml` e e renderizada pelo script `infra/scripts/bootstrap.sh`.

## Fluxo de Deploy

```bash
cd micro_api_26.1
source infra/.env
infra/scripts/bootstrap.sh
infra/scripts/deploy-all.sh
```

O bootstrap cria o cluster com `eksctl`, atualiza o `kubeconfig`, instala o `ingress-nginx` com service `LoadBalancer` e cria o namespace `store-platform`.

O deploy aplica:

- Redis no cluster.
- ConfigMaps, Secrets, Deployments e Services dos seis microservicos.
- HPA de `gateway-service`, `product-service` e `order-service`.
- Ingress do `gateway-service`, que publica a entrada HTTP da aplicacao.

## Validacao

```bash
kubectl config current-context
kubectl -n store-platform get deploy,svc,hpa,ingress
kubectl -n store-platform get pods -o wide
kubectl -n ingress-nginx get svc
```

Pegue o DNS externo do ingress controller:

```bash
kubectl -n ingress-nginx get svc ingress-nginx-controller
```

Teste a entrada publica:

```bash
curl http://DNS_DO_LOAD_BALANCER/
curl http://DNS_DO_LOAD_BALANCER/products
```

Guarde prints desses comandos para a documentacao e para o video.
