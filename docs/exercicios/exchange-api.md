# Exchange API

## Objetivo

Implementar um microservico simples de cotacoes para dar suporte a conversao de moeda do `order-service`.

## Entregue

- `GET /exchanges/{from}/{to}`
- alias oculto para `/exchange/{from}/{to}`
- exigencia do header `id-account`
- healthcheck em `GET /`
- metricas em `GET /metrics`
- traducao de erros do provedor externo

## Integracao externa

- Fonte: AwesomeAPI
- `sell` mapeado a partir de `ask`
- `buy` mapeado a partir de `bid`

## Arquivos principais

- `exchange/app/main.py`
- `exchange/app/services/exchange_service.py`
- `exchange/app/clients/awesome_api_client.py`
- `exchange/app/models.py`
- `exchange/app/exceptions.py`

## Cobertura de testes

Casos exercitados:

- cotacao valida
- ausencia de `id-account`
- moeda invalida
- rejeicao do provedor
- falha do provedor
- exposicao do endpoint de metricas

Arquivo:

- `exchange/tests/test_exchange_api.py`
