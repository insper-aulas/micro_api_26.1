# Order API

## Objetivo

Implementar o microservico de pedidos integrando com o microservico de produtos e respeitando o header `id-account` como identidade do usuario.

## Entregue

- `POST /orders`
- `GET /orders`
- `GET /orders/{id}`
- filtro de pedidos por conta
- conversao opcional de moeda em `GET /orders/{id}?currency=BRL`
- tratamento de `401`, `400`, `404` e `422`
- healthcheck em `GET /`

## Regras principais

- cada pedido pertence a um `id-account`
- a criacao do pedido valida os produtos consultando o `product-service`
- totais sao calculados no `order-service`
- a moeda padrao da resposta detalhada e `USD`

## Arquivos principais

- `order-service/src/main/java/store/order/resource/OrderResource.java`
- `order-service/src/main/java/store/order/service/OrderService.java`
- `order-service/src/main/java/store/order/service/OrderMapper.java`
- `order-service/src/main/java/store/order/config/FeignHeaderPropagationConfig.java`
- `order-service/src/main/java/store/order/exception/RestExceptionHandler.java`

## Cobertura de testes

Casos exercitados:

- criacao bem-sucedida de pedido
- listagem por conta
- consulta detalhada em `USD`
- conversao para outra moeda
- `404` para pedido de outra conta
- `400` para produto invalido
- `422` para moeda invalida
- `401` sem header de conta
- healthcheck

Arquivo:

- `order-service/src/test/java/store/order/OrderResourceIntegrationTest.java`
