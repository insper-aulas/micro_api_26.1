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

## Pendencias Finais

- Executar o deploy em AWS/EKS real.
- Rodar os pipelines Jenkins apontando para o EKS.
- Gravar o video do teste de carga mostrando o HPA.
- Completar os links de slides e video.
- Inserir prints em `docs/evidence/screenshots/`.
- Registrar a estimativa da AWS Pricing Calculator.

## Bottlenecks destacados

- `Caching`: o `product-service` usa Redis com `Spring Cache` para reduzir leituras repetidas no banco.
- `Observability`: `account-service`, `auth-service`, `gateway-service`, `product-service` e `order-service` expoem metricas para Prometheus, e `exchange-service` expoe `GET /metrics`, com Grafana provisionado para consulta.
