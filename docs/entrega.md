# Entrega

## Identificacao

- Alunos:
  - `Pedro Henrique Vargas Sepulveda`
  - `Raphael Cimerman Lafer`
- Repositorio: [`insper-aulas/micro_api_26.1`](https://github.com/insper-aulas/micro_api_26.1)

## Itens cobertos nesta documentacao

- Nome dos alunos e identificacao da entrega.
- Documentacao das atividades realizadas em cada exercicio individual.
- Codigo-fonte do projeto no mesmo repositorio.
- Arquitetura, execucao local, observabilidade e validacao.
- Link do repositorio principal utilizado na entrega.
- Destaques dos bottlenecks implementados.

## Links importantes

- Repositorio do projeto: <https://github.com/insper-aulas/micro_api_26.1>
- Documentacao publicada: <https://insper-aulas.github.io/micro_api_26.1/>
- Atividades implementadas:
  - [Product API](exercicios/product-api.md) - [repositorio](https://github.com/insper-aulas/product-service)
  - [Order API](exercicios/order-api.md) - [repositorio](https://github.com/insper-aulas/order-service)
  - [Exchange API](exercicios/exchange-api.md) - [repositorio](https://github.com/insper-aulas/exchange)
  - [Jenkins](exercicios/jenkins.md) - [repositorio agregador](https://github.com/insper-aulas/micro_api_26.1)
  - [MiniKube](exercicios/minikube.md) - [repositorio agregador](https://github.com/insper-aulas/micro_api_26.1)
  - [Bottlenecks](exercicios/bottlenecks.md) - [repositorio agregador](https://github.com/insper-aulas/micro_api_26.1)

## Apresentacao e video

- Slides: pendente de publicacao externa.
- Video: pendente de publicacao externa.

## Pendencias Finais

- Anexar evidencias finais do deploy em AWS/EKS real.
- Anexar evidencias dos pipelines Jenkins apontando para o EKS.
- Gravar o video do teste de carga mostrando o HPA.
- Completar os links de slides e video.
- Inserir prints em `docs/evidence/screenshots/`.
- Revisar a estimativa final da AWS Pricing Calculator contra o custo observado no console.

## Bottlenecks destacados

- `Caching`: o `product-service` usa Redis com `Spring Cache` para reduzir leituras repetidas no banco.
- `Observability`: `account-service`, `auth-service`, `gateway-service`, `product-service` e `order-service` expoem metricas para Prometheus, e `exchange-service` expoe `GET /metrics`, com Grafana provisionado para consulta.
