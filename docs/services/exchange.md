# Exchange Service

O `exchange-service` e o microservico individual do Raphael Cimerman Lafer. Ele retorna cotacoes de compra e venda para conversao de moeda e e usado pelo `order-service` quando um pedido precisa ser exibido em outra moeda.

## Identificacao

| Item | Valor |
| --- | --- |
| Responsavel | Raphael Cimerman Lafer |
| Repositorio | [`exchange`](https://github.com/insper-aulas/exchange) |
| Documentacao individual | <https://raphaellafer.github.io/projeto_individual_api/> |
| Papel na arquitetura | Consulta de cambio para pedidos em moedas diferentes |

## Video de Load Test

Este video apresenta o Load Test do `exchange-service`, microservico responsavel por consultar cotacoes de cambio.

[Assistir ao video do Load Test do exchange-service](https://youtu.be/LTDJSoIG2sQ)

## Contrato principal

```http
GET /exchanges/USD/BRL
id-account: load-test-account
```

Resposta esperada:

```json
{
  "sell": 5.0038,
  "buy": 5.0008,
  "date": "2026-05-14 12:35:24",
  "id-account": "load-test-account"
}
```

O header `id-account` e obrigatorio porque o servico recebe o contexto de conta propagado pelos servicos internos da trusted layer.

## Fluxo no projeto

```text
gateway-service -> order-service -> exchange-service -> AwesomeAPI
```

O `gateway-service` recebe a requisicao externa e propaga o identificador da conta. O `order-service` consulta o `exchange-service` quando precisa converter valores, e o `exchange-service` busca a cotacao atual na AwesomeAPI.

## Runtime

- Python
- FastAPI
- Uvicorn
- Requests para integracao HTTP com a AwesomeAPI
- `prometheus-fastapi-instrumentator` para metricas em `/metrics`

## Comportamento de erro

| Situacao | Resposta |
| --- | --- |
| Header `id-account` ausente | `401 Unauthorized` |
| Moeda invalida ou par nao suportado | `422 Unprocessable Entity` |
| Falha ou resposta inesperada da AwesomeAPI | `502 Bad Gateway` |

## Observabilidade

O servico expoe `GET /metrics`, permitindo acompanhar quantidade de requisicoes, latencia e erros HTTP durante execucao local, Kubernetes ou teste de carga.

## Pontos de atencao

- O tempo de resposta depende parcialmente da AwesomeAPI, que e uma dependencia externa.
- O Load Test do video exercita esse caminho real do servico, incluindo validacao do endpoint principal.
- Para reduzir risco operacional, o servico trata timeouts, erros externos e entradas invalidas com respostas explicitas.
