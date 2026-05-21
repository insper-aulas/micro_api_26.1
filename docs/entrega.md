# Entrega

## Identificacao

- Aluno: `Pedro Henrique Vargas Sepulveda`
- Repositorio: [`pedro-vs/projeto_API_individual`](https://github.com/pedro-vs/projeto_API_individual)

## Itens cobertos nesta documentacao

- Nome do aluno e identificacao da entrega.
- Documentacao das atividades realizadas em cada exercicio individual.
- Codigo-fonte do projeto no mesmo repositorio.
- Arquitetura, execucao local, observabilidade e validacao.
- Link do repositorio principal utilizado na entrega.
- Destaques dos bottlenecks implementados.

## Links importantes

- Repositorio do projeto: <https://github.com/pedro-vs/projeto_API_individual>
- Handout da disciplina: <https://insper.github.io/platform/versions/2026.1/>
- Sequencia individual:
  - <https://insper.github.io/platform/exercises/product/>
  - <https://insper.github.io/platform/exercises/order/>
  - <https://insper.github.io/platform/exercises/exchange/>
  - <https://insper.github.io/platform/exercises/jenkins/>
  - <https://insper.github.io/platform/exercises/minikube/>
  - <https://insper.github.io/platform/exercises/bottlenecks/>

## Apresentacao e video

- Slides: pendente de publicacao externa.
- Video: pendente de publicacao externa.

## Bottlenecks destacados

- `Caching`: o `product-service` usa Redis com `Spring Cache` para reduzir leituras repetidas no banco.
- `Observability`: `account-service`, `auth-service`, `gateway-service`, `product-service` e `order-service` expoem metricas para Prometheus, e `exchange-service` expoe `GET /metrics`, com Grafana provisionado para consulta.
