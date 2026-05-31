# Bottlenecks

## Objetivo

Implementar ao menos dois tratamentos de gargalo relevantes para a aplicacao.

## Bottlenecks escolhidos

### `Caching`

Problema tratado: consultas repetidas de produtos podem gerar leituras desnecessarias no banco, especialmente em listagens e em chamadas de pedido que consultam detalhes de produto.

Solucao implementada:

- Redis como armazenamento em memoria.
- `GET /products` cacheado com chave `all`.
- `GET /products/{id}` cacheado por `UUID`.
- Integracao com Spring Cache no `product-service`.

Efeito esperado:

- diminuir consultas repetidas ao banco;
- reduzir latencia em leituras frequentes;
- aliviar o `product-service` durante picos de acesso.

Arquivos principais:

- `product-service/src/main/java/store/product/config/CacheConfig.java`
- `product-service/src/main/java/store/product/service/ProductService.java`
- `product-service/src/main/resources/application.properties`

### `Observability`

Problema tratado: sem metricas, uma falha de performance durante carga vira apenas "a API ficou lenta", sem indicios claros de qual servico degradou.

Solucao implementada:

- `account-service`, `auth-service`, `gateway-service`, `product-service` e `order-service` com actuator + Micrometer Prometheus.
- `exchange-service` com `prometheus-fastapi-instrumentator`.
- `compose.yaml` com Prometheus e Grafana.
- datasource do Grafana provisionado automaticamente.

Efeito esperado:

- acompanhar requisicoes, latencia e erros por servico;
- apoiar a analise durante Load Test;
- diferenciar falha de aplicacao, falha de dependencia externa e saturacao de recurso.

Arquivos principais:

- `compose.yaml`
- `observability/prometheus/prometheus.yml`
- `observability/grafana/provisioning/datasources/datasources.yml`
- `exchange/app/main.py`

## Resultado pratico

- reducao do custo de leitura repetida no `product-service`;
- metricas de aplicacao disponiveis para inspecao;
- stack observavel localmente sem configuracao manual adicional;
- `exchange-service` instrumentado para acompanhar a dependencia da AwesomeAPI durante testes.

## Relacao com o Load Test

O teste de carga ajuda a validar se os gargalos tratados continuam sob controle quando ha mais requisicoes simultaneas. No caso do `exchange-service`, o video publicado mostra a execucao do teste no endpoint de cambio, que depende de uma chamada externa e por isso e um bom ponto de observacao.

Video do Load Test do `exchange-service`: <https://youtu.be/LTDJSoIG2sQ>
