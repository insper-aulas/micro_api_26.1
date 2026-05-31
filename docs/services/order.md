# Order Service

O `order-service` e um dos microservicos individuais do Pedro Henrique Vargas Sepulveda. Ele cria e consulta pedidos vinculados a uma conta, valida os produtos no `product-service` e usa o `exchange-service` quando o total precisa ser exibido em outra moeda.

## Identificacao

| Item | Valor |
| --- | --- |
| Responsavel | Pedro Henrique Vargas Sepulveda |
| Repositorio | [`order-service`](https://github.com/insper-aulas/order-service) |
| Documentacao individual | <https://pedro-vs.github.io/projeto_API_individual/> |
| Papel na arquitetura | Criacao, listagem e consulta de pedidos por conta |

## Video de demonstracao

Este video apresenta o funcionamento do `product-service` e do `order-service`, incluindo a criacao e a consulta de produtos e pedidos.

[Assistir ao video de demonstracao de Product e Order](https://youtu.be/uk1mvr0giKE)

## Contrato principal

```http
POST /orders
id-account: aluno-pedro
Content-Type: application/json

{
  "items": [
    {
      "idProduct": "d6057d95-c99c-4815-9587-017ad0f6486b",
      "quantity": 2
    }
  ]
}
```

Resposta esperada:

```json
{
  "id": "014f2ac1-d6ad-46a1-9391-e2203842405f",
  "date": "2026-05-31T18:30:00",
  "total": 7000.00,
  "items": [
    {
      "product": {
        "id": "d6057d95-c99c-4815-9587-017ad0f6486b"
      },
      "quantity": 2,
      "total": 7000.00
    }
  ]
}
```

O header `id-account` e obrigatorio porque cada pedido pertence a uma conta. No fluxo externo, o `gateway-service` autentica o usuario e propaga esse contexto para a trusted layer.

Consulta com conversao opcional:

```http
GET /orders/{id}?currency=BRL
id-account: aluno-pedro
```

Endpoints disponiveis:

| Metodo | Endpoint | Finalidade |
| --- | --- | --- |
| `POST` | `/orders` | Criar pedido |
| `GET` | `/orders` | Listar pedidos da conta |
| `GET` | `/orders/{id}` | Consultar pedido em `USD` ou converter com `?currency=` |

## Fluxo no projeto

```text
gateway-service -> order-service -> PostgreSQL
                       |
                       +-------> product-service
                       |
                       +-------> exchange-service -> AwesomeAPI
```

O `order-service` consulta o `product-service` ao criar um pedido e calcula os totais dos itens. Ao consultar detalhes em outra moeda, ele solicita ao `exchange-service` a cotacao de venda partindo de `USD`.

## Runtime

- Java 21
- Spring Boot
- Spring Data JPA
- PostgreSQL com schema `orders`
- Flyway para migracoes
- OpenFeign para integracao HTTP com Product Service e Exchange Service
- Timeout de 2 segundos nas chamadas internas
- Spring Actuator e Micrometer para metricas Prometheus

## Comportamento de erro

| Situacao | Resposta |
| --- | --- |
| Header `id-account` ausente ou vazio | `401 Unauthorized` |
| Corpo da requisicao invalido | `400 Bad Request` |
| Produto invalido ao criar pedido | `400 Bad Request` |
| Pedido inexistente ou pertencente a outra conta | `404 Not Found` |
| Moeda nao suportada | `422 Unprocessable Entity` |
| Falha no Product Service ou Exchange Service | `502 Bad Gateway` |

## Observabilidade

O servico expoe `GET /actuator/health` e `GET /actuator/prometheus`. Os manifests Kubernetes incluem probes de saude, recursos e HPA com alvo de 70% de uso de CPU.

## Pontos de atencao

- A criacao de pedidos depende da disponibilidade do `product-service`.
- A conversao de moeda depende do `exchange-service`, que por sua vez consulta a AwesomeAPI.
- O filtro por `id-account` impede que uma conta visualize pedidos de outra conta.
- Os identificadores de conta e o header `Authorization` sao propagados nas chamadas internas feitas com OpenFeign.
