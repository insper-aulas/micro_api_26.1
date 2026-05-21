# Bottlenecks

## Objetivo

Implementar ao menos dois tratamentos de gargalo relevantes para a aplicacao.

## Bottlenecks escolhidos

### `Caching`

- Implementado no `product-service`
- Redis como armazenamento em memoria
- `GET /products` cacheado com chave `all`
- `GET /products/{id}` cacheado por `UUID`

Arquivos principais:

- `product-service/src/main/java/store/product/config/CacheConfig.java`
- `product-service/src/main/java/store/product/service/ProductService.java`
- `product-service/src/main/resources/application.properties`

### `Observability`

- `account-service`, `auth-service`, `gateway-service`, `product-service` e `order-service` com actuator + Micrometer Prometheus
- `exchange-service` com `prometheus-fastapi-instrumentator`
- `compose.yaml` com Prometheus e Grafana
- datasource do Grafana provisionado automaticamente

Arquivos principais:

- `compose.yaml`
- `observability/prometheus/prometheus.yml`
- `observability/grafana/provisioning/datasources/datasources.yml`
- `exchange/app/main.py`

## Resultado pratico

- reducao do custo de leitura repetida no `product-service`
- metricas de aplicacao disponiveis para inspecao
- stack observavel localmente sem configuracao manual adicional
