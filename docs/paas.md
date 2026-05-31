# PaaS

Esta pagina registra como o projeto usa servicos de plataforma para executar a aplicacao sem precisar administrar toda a infraestrutura manualmente.

## Contexto do projeto

A aplicacao e composta por seis microservicos, banco PostgreSQL, Redis, observabilidade e ingress HTTP. Para a entrega, o grupo preparou a execucao em containers e Kubernetes, com publicacao da documentacao em GitHub Pages.

## Plataformas utilizadas

| Tecnologia | Papel no projeto | Por que entra como plataforma |
| --- | --- | --- |
| Amazon EKS | Orquestracao Kubernetes | A AWS gerencia o plano de controle do Kubernetes |
| AWS RDS PostgreSQL | Banco relacional | Banco gerenciado, com operacao e armazenamento providos pela AWS |
| Docker Hub ou registry externo | Distribuicao de imagens | Armazena e entrega imagens Docker para deploy |
| GitHub Pages | Publicacao do MkDocs | Hospeda o site estatico com HTTPS |

## O que continua sob responsabilidade do grupo

- Codigo dos microservicos.
- `Dockerfile` de cada servico.
- Manifests Kubernetes.
- Configuracao de variaveis e secrets.
- Pipelines Jenkins.
- Decisao de quando criar ou destruir a infraestrutura para controlar custo.

## O que a plataforma abstrai

- Criacao e disponibilidade do control plane do Kubernetes.
- Provisionamento do endpoint publico via Load Balancer.
- Operacao basica do banco gerenciado, quando RDS e usado.
- Hospedagem do site MkDocs sem servidor proprio.

## Variaveis principais

Os servicos precisam receber variaveis de banco, cache e integracoes:

- `DATABASE_HOST`
- `DATABASE_PORT`
- `DATABASE_DB`
- `DATABASE_USERNAME`
- `DATABASE_PASSWORD`
- `REDIS_HOST`
- `REDIS_PORT`
- variaveis especificas do `exchange-service`, como URL e timeout da AwesomeAPI

## Trade-offs

| Escolha | Beneficio | Custo ou risco |
| --- | --- | --- |
| EKS | Kubernetes real, HPA e manifests proximos de producao | Custo fixo enquanto o cluster estiver ativo |
| RDS | Banco gerenciado e mais proximo de producao | Custo adicional em relacao a Postgres no cluster |
| Redis no cluster | Simples para demo e barato | Nao tem a mesma disponibilidade de um Redis gerenciado |
| Jenkins self-managed | Controle do pipeline da disciplina | O grupo opera o Jenkins |

## Conclusao

O desenho atende ao objetivo da disciplina porque usa Kubernetes gerenciado, banco/plataforma externa quando aplicavel, imagens containerizadas e documentacao publicada. Para uma entrega academica, o ponto mais importante e manter a infraestrutura temporaria e destruir recursos depois da demonstracao para evitar custo desnecessario.
