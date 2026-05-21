# Validacao

## Testes automatizados

Comandos utilizados:

```bash
cd ../account-service && ./mvnw -B test
cd ../auth-service && ./mvnw -B test
cd ../gateway-service && ./mvnw -B test
cd ../product-service && ./mvnw -B test
cd ../order-service && ./mvnw -B test
cd ../exchange && pytest -q
```

Resultado observado em `2026-05-14`:

- `account-service`: `6` testes passando
- `auth-service`: `5` testes passando
- `gateway-service`: `5` testes passando
- `product-service`: `8` testes passando
- `order-service`: `9` testes passando
- `exchange-service`: `6` testes passando

## Validacao funcional local

Fluxo validado com `docker compose up -d --build`:

- Healthcheck em `GET /` para `account-service`, `gateway-service`, `product-service`, `order-service` e `exchange-service`, e em `GET /auth/` para `auth-service`.
- Cadastro em `POST /auth/register`.
- Login em `POST /auth/login` com recebimento do cookie JWT.
- Consulta de identidade em `GET /auth/whoami`.
- Criacao de produto em `POST /products` via `gateway-service`.
- Criacao de pedido em `POST /orders` via `gateway-service`.
- Consulta de pedido em `GET /orders/{id}` via `gateway-service`.
- Conversao de moeda em `GET /orders/{id}?currency=BRL` via `gateway-service`.
- Consulta de cambio em `GET /exchanges/USD/BRL` via `gateway-service`.
- Coleta de metricas em:
  - `GET /actuator/prometheus` no `account-service`
  - `GET /actuator/prometheus` no `auth-service`
  - `GET /actuator/prometheus` no `gateway-service`
  - `GET /actuator/prometheus` no `product-service`
  - `GET /actuator/prometheus` no `order-service`
  - `GET /metrics` no `exchange-service`

## Validacao de observabilidade

Os seguintes endpoints foram checados localmente:

- Prometheus health: `http://localhost:9090/-/healthy`
- Grafana health: `http://localhost:3000/api/health`

## Validacao de cluster local

Arquivos de orquestracao versionados:

- `k8s/namespace.yaml`
- `account-service/k8s/*.yaml`
- `auth-service/k8s/*.yaml`
- `gateway-service/k8s/*.yaml`
- `product-service/k8s/*.yaml`
- `order-service/k8s/*.yaml`
- `exchange/k8s/*.yaml`
- `k8s/postgres/*.yaml`
- `k8s/redis/*.yaml`

Scripts:

- `scripts/k8s/deploy-local-cluster.sh`
- `scripts/k8s/check-health.sh`
- `scripts/k8s/kind-config.yaml`
- `scripts/k8s/install-kind.sh`

Fluxo validado em `2026-05-14` com `kind-store`:

```bash
./scripts/k8s/install-kind.sh
./scripts/k8s/bin/kind create cluster --name store --config scripts/k8s/kind-config.yaml
./scripts/k8s/deploy-local-cluster.sh
./scripts/k8s/check-health.sh
```

Resultado observado:

- cluster `kind-store` criado com sucesso
- imagens locais carregadas nos dois nodes do cluster
- `postgres`, `redis`, `account-service`, `auth-service`, `gateway-service`, `product-service`, `order-service` e `exchange-service` em `Running`
- `./scripts/k8s/check-health.sh` retornando `All services and the gateway flow responded successfully.`

## Publicacao da documentacao

O repositorio agora possui `mkdocs.yml`, `requirements-docs.txt` e a pipeline `.github/workflows/docs.yml`. Ao publicar no ramo `main`, o `GitHub Pages` pode gerar este site automaticamente.
