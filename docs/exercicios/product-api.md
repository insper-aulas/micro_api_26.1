# Product API

## Objetivo

Implementar um microservico de produtos com operacoes CRUD basicas, seguindo o padrao REST usado em aula.

## Entregue

- `POST /products`
- `GET /products`
- `GET /products/{id}`
- `DELETE /products/{id}`
- validacao de payload com mensagens claras
- tratamento de `404` para produto inexistente
- healthcheck em `GET /`

## Arquivos principais

- `product-service/src/main/java/store/product/resource/ProductResource.java`
- `product-service/src/main/java/store/product/service/ProductService.java`
- `product-service/src/main/java/store/product/model/Product.java`
- `product-service/src/main/java/store/product/dto/ProductIn.java`
- `product-service/src/main/java/store/product/exception/RestExceptionHandler.java`

## Cobertura de testes

Casos exercitados:

- criacao de produto
- listagem
- busca por id
- remocao
- validacao de request invalida
- erro `404`
- healthcheck
- cache em leitura repetida por id

Arquivo:

- `product-service/src/test/java/store/product/ProductResourceIntegrationTest.java`
