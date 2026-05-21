# Arquitetura

## Servicos implementados

### `account-service`

- Responsavel por criar contas, buscar conta por id e validar credenciais.
- Persistencia com JPA + PostgreSQL, versionada por Flyway.
- Armazena senha com `BCrypt`.

### `auth-service`

- Responsavel por registrar usuario, autenticar e emitir JWT.
- Consome `account-service` via OpenFeign.
- Publica o token no cookie `__store_jwt_token`.

### `gateway-service`

- Responsavel por expor uma entrada unica para o cliente.
- Roteia chamadas para `account-service`, `auth-service`, `product-service`, `order-service` e `exchange-service`.
- Resolve o JWT com `auth-service` e injeta `id-account` nas rotas protegidas.

### `product-service`

- Responsavel por criar, listar, consultar e remover produtos.
- Persistencia com JPA + PostgreSQL, versionada por Flyway.
- Cache de leitura com Redis para `GET /products` e `GET /products/{id}`.

### `order-service`

- Responsavel por criar pedidos e consultar pedidos por conta.
- Usa o header `id-account` como contexto de identidade do usuario.
- Consulta o `product-service` para validar produtos e precos.
- Consulta o `exchange-service` para conversao opcional de moeda.

### `exchange-service`

- Responsavel por retornar cotacoes de moeda.
- Consome a AwesomeAPI externamente.
- Expoe `sell` e `buy` com base em `ask` e `bid`.

## Integracoes

| Origem | Destino | Objetivo |
| --- | --- | --- |
| `auth-service` | `account-service` | Registrar conta e validar email/senha |
| `gateway-service` | `auth-service` | Resolver JWT antes de encaminhar requisicoes protegidas |
| `gateway-service` | `account-service` | Encaminhar operacoes de conta |
| `gateway-service` | `product-service` | Encaminhar operacoes de produto |
| `gateway-service` | `order-service` | Encaminhar operacoes de pedido |
| `gateway-service` | `exchange-service` | Encaminhar operacoes de cambio |
| `order-service` | `product-service` | Buscar produto por id durante a criacao do pedido |
| `order-service` | `exchange-service` | Converter total do pedido para outra moeda |
| `exchange-service` | AwesomeAPI | Buscar cotacoes em tempo real |
| `product-service` | Redis | Armazenar respostas cacheadas |
| Prometheus | APIs | Coletar metricas |
| Grafana | Prometheus | Visualizar metricas |

## Organizacao do repositorio

```text
.
|- account-service/
|- auth-service/
|- gateway-service/
|- product-service/
|- order-service/
|- exchange/
|- infra/
|- jenkins/
|- observability/
|- scripts/k6/
|- scripts/k8s/
|- k8s/
|- compose.yaml
|- mkdocs.yml
`- docs/
```

## Decisoes de implementacao

- Foi mantida a separacao por microservico, cada um com seu proprio `Dockerfile` e `Jenkinsfile`.
- Os servicos Java seguem uma estrutura em camadas com `resource`, `service`, `dto`, `model` e `repository`.
- O `gateway-service` centraliza autenticacao e propagacao de identidade.
- O `order-service` propaga `id-account` e `Authorization` nas chamadas internas para seguir o padrao visto em aula.
- As manifestacoes de erro foram padronizadas com respostas `problem+json` ou equivalentes.

## Arquivos principais

- `account-service/src/main/java/store/account/resource/AccountResource.java`
- `auth-service/src/main/java/store/auth/resource/AuthResource.java`
- `gateway-service/src/main/java/store/gateway/security/AuthorizationFilter.java`
- `product-service/src/main/java/store/product/service/ProductService.java`
- `order-service/src/main/java/store/order/service/OrderService.java`
- `exchange/app/main.py`
- `compose.yaml`
- `account-service/k8s/*.yaml`
- `auth-service/k8s/*.yaml`
- `gateway-service/k8s/*.yaml`
- `product-service/k8s/*.yaml`
- `order-service/k8s/*.yaml`
- `exchange/k8s/*.yaml`
- `infra/`
- `jenkins/`
- `scripts/k6/`
