# Projeto API Individual

Este repositorio consolida a entrega individual das etapas de microservices da disciplina **Platforms, Microservices, DevOps and APIs**. O projeto foi organizado como uma loja simples com a trusted layer completa e um servico externo de cambio:

- `account-service`: cadastro de contas e validacao de credenciais.
- `auth-service`: emissao e resolucao de JWT.
- `gateway-service`: entrada unica da aplicacao.
- `product-service`: cadastro e consulta de produtos.
- `order-service`: criacao e consulta de pedidos por conta.
- `exchange-service`: consulta de cotacoes para conversao de moeda.

## Status da entrega

| Area | Status | Evidencia |
| --- | --- | --- |
| APIs base | Concluida | `account-service`, `auth-service`, `gateway-service`, `product-service`, `order-service` e `exchange-service` respondendo localmente |
| CI/CD | Concluida no repositorio | `Jenkinsfile` por servico e `Dockerfile` versionados |
| Kubernetes | Concluida no repositorio e validada localmente | manifests separados por servico e scripts de deploy |
| Bottlenecks | Concluida | Redis cache + Prometheus + Grafana |
| Documentacao | Concluida | Este site em `MkDocs` com publicacao por `GitHub Pages` |

## Videos dos servicos individuais

- `exchange-service`: [video de Load Test no YouTube](https://youtu.be/LTDJSoIG2sQ)
- `product-service` e `order-service`: [video de demonstracao no YouTube](https://youtu.be/uk1mvr0giKE)

## O que esta documentado aqui

- Visao geral da entrega individual.
- Arquitetura e integracoes entre servicos.
- Como executar a stack local com `docker compose`.
- Como validar testes, endpoints, metricas e cluster local.
- Resumo de cada exercicio pedido na sequencia individual.

## Stack utilizada

| Componente | Tecnologia |
| --- | --- |
| APIs Java | Spring Boot 3.5, Maven, JPA, PostgreSQL e Flyway |
| API Python | FastAPI, Uvicorn |
| Cache | Redis |
| Observabilidade | Prometheus, Grafana, Micrometer |
| Containers | Docker, Docker Compose |
| Orquestracao | Kubernetes local com `kind` ou `minikube` |
| Documentacao | MkDocs Material |

## Navegacao rapida

- A pagina [Entrega](entrega.md) resume os itens pedidos no handout.
- A secao [Projeto](projeto/arquitetura.md) descreve arquitetura, execucao e validacao.
- A secao [Exercicios](exercicios/product-api.md) registra cada etapa implementada.
