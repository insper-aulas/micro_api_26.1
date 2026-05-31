# Product Service

O `product-service` e um dos microservicos individuais do Pedro Henrique Vargas Sepulveda. Ele gerencia o catalogo de produtos da loja, persiste os dados em PostgreSQL e usa Redis para reduzir leituras repetidas no banco. O `order-service` consulta este servico antes de incluir um produto em um pedido.

## Identificacao

| Item | Valor |
| --- | --- |
| Responsavel | Pedro Henrique Vargas Sepulveda |
| Repositorio | [`product-service`](https://github.com/insper-aulas/product-service) |
| Documentacao individual | <https://pedro-vs.github.io/projeto_API_individual/> |
| Papel na arquitetura | Cadastro, consulta e remocao de produtos do catalogo |

## Video de demonstracao

Este video apresenta o funcionamento do `product-service` e do `order-service`, incluindo a criacao e a consulta de produtos e pedidos.

[Assistir ao video de demonstracao de Product e Order](https://youtu.be/uk1mvr0giKE)

## Contrato principal

```http
POST /products
Content-Type: application/json

{
  "name": "Notebook",
  "price": 3500.00,
  "unit": "unidade"
}
```

Resposta esperada:

```json
{
  "id": "d6057d95-c99c-4815-9587-017ad0f6486b",
  "name": "Notebook",
  "price": 3500.00,
  "unit": "unidade"
}
```

Endpoints disponiveis:

| Metodo | Endpoint | Finalidade |
| --- | --- | --- |
| `POST` | `/products` | Cadastrar produto |
| `GET` | `/products` | Listar produtos |
| `GET` | `/products/{id}` | Consultar produto por identificador |
| `DELETE` | `/products/{id}` | Remover produto |

## Fluxo no projeto

```text
gateway-service -> product-service -> Redis
                           |
                           +-------> PostgreSQL

order-service -> product-service
```

O `gateway-service` encaminha as requisicoes externas do catalogo. O `product-service` consulta o Redis antes de repetir leituras no PostgreSQL, e o `order-service` usa `GET /products/{id}` para validar os itens de um novo pedido.

## Runtime

- Java 21
- Spring Boot
- Spring Data JPA
- PostgreSQL com schema `products`
- Flyway para migracoes
- Spring Cache com Redis e TTL de 10 minutos
- Spring Actuator e Micrometer para metricas Prometheus

## Comportamento de erro

| Situacao | Resposta |
| --- | --- |
| Corpo da requisicao invalido | `400 Bad Request` |
| Produto inexistente em consulta ou remocao | `404 Not Found` |

As validacoes exigem nome, preco maior que zero e unidade. O preco aceita no maximo duas casas decimais.

## Observabilidade

O servico expoe `GET /actuator/health` e `GET /actuator/prometheus`. Os manifests Kubernetes incluem probes de saude, recursos e HPA com alvo de 70% de uso de CPU.

## Pontos de atencao

- O Redis e usado como cache, mas o PostgreSQL continua sendo a fonte persistente dos produtos.
- A criacao e a remocao invalidam o cache para evitar dados desatualizados.
- A disponibilidade do catalogo afeta a criacao de pedidos, pois o `order-service` valida cada produto antes de salvar um pedido.
