# Execucao Local

## Subindo a stack completa

O jeito mais rapido de executar o projeto e subir todos os servicos com observabilidade:

```bash
docker compose up -d --build
```

Servicos publicados:

- `gateway-service`: <http://localhost:8085>
- `account-service`: <http://localhost:8083>
- `auth-service`: <http://localhost:8084>
- `product-service`: <http://localhost:8080>
- `order-service`: <http://localhost:8081>
- `exchange-service`: <http://localhost:8000>
- `prometheus`: <http://localhost:9090>
- `grafana`: <http://localhost:3000>
- `redis`: `localhost:6379`
- `postgres`: `localhost:5432`

Fluxo recomendado:

- usar o `gateway-service` como ponto de entrada para autenticacao e chamadas protegidas.

Os comandos abaixo assumem que os repositorios dos servicos estao como pastas irmas de `micro_api_26.1`.

## Subindo servicos isoladamente

### Account API

```bash
cd ../account-service
export DATABASE_HOST=localhost DATABASE_PORT=5432 DATABASE_DB=store DATABASE_USERNAME=store DATABASE_PASSWORD=devpass
./mvnw spring-boot:run
```

### Auth API

```bash
cd ../auth-service
./mvnw spring-boot:run
```

### Gateway API

```bash
cd ../gateway-service
./mvnw spring-boot:run
```

### Product API

```bash
cd ../product-service
export DATABASE_HOST=localhost DATABASE_PORT=5432 DATABASE_DB=store DATABASE_USERNAME=store DATABASE_PASSWORD=devpass
export REDIS_HOST=localhost REDIS_PORT=6379
./mvnw spring-boot:run
```

### Order API

```bash
cd ../order-service
export DATABASE_HOST=localhost DATABASE_PORT=5432 DATABASE_DB=store DATABASE_USERNAME=store DATABASE_PASSWORD=devpass
export PRODUCT_SERVICE_URL=http://localhost:8080 EXCHANGE_SERVICE_URL=http://localhost:8000
./mvnw spring-boot:run
```

### Exchange API

```bash
cd ../exchange
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

## Endpoints principais

### Account API

- `POST /accounts`
- `GET /accounts/{id}`
- `POST /accounts/search`

### Auth API

- `POST /auth/register`
- `POST /auth/login`
- `GET /auth/logout`
- `POST /auth/solve`
- `GET /auth/whoami`

### Product API

- `POST /products`
- `GET /products`
- `GET /products/{id}`
- `DELETE /products/{id}`

### Order API

- `POST /orders`
- `GET /orders`
- `GET /orders/{id}`

### Exchange API

- `GET /exchanges/{from}/{to}`

## Exemplo de fluxo

Registrar usuario:

```bash
curl -X POST http://localhost:8085/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Alice",
    "email": "alice@example.com",
    "password": "123456"
  }'
```

Login e gravacao do cookie:

```bash
curl -i -c cookies.txt \
  -X POST http://localhost:8085/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "alice@example.com",
    "password": "123456"
  }'
```

Criar produto:

```bash
curl -b cookies.txt \
  -X POST http://localhost:8085/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Notebook",
    "price": 4500.0,
    "unit": "UN"
  }'
```

Criar pedido:

```bash
curl -b cookies.txt \
  -X POST http://localhost:8085/orders \
  -H "Content-Type: application/json" \
  -d '{
    "items": [
      {
        "idProduct": "PRODUCT_ID",
        "quantity": 2
      }
    ]
  }'
```

Consultar pedido com conversao:

```bash
curl -b cookies.txt \
  "http://localhost:8085/orders/ORDER_ID?currency=BRL"
```

## Grafana

Login padrao:

- usuario: `admin`
- senha: `admin`
