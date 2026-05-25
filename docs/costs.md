# Costs

A infra em AWS deve ser temporaria e usada apenas para demonstracao, porque EKS, EC2, RDS e Load Balancer geram custo enquanto estiverem ativos.

## Principais Custos

| Item | Uso no projeto | Como reduzir |
| --- | --- | --- |
| EKS control plane | Kubernetes gerenciado | Apagar o cluster ao final da demo |
| EC2 nodes | Nos de trabalho do EKS | Usar `t3.small` ou menor aprovado e poucas replicas |
| EBS | Disco dos nodes e RDS | Manter volumes pequenos |
| RDS PostgreSQL | Banco persistente | Usar `db.t3.micro`, sem multi-AZ, ou banco no cluster para demo |
| Load Balancer | Entrada publica do ingress-nginx | Remover junto com o cluster |
| NAT Gateway | Saida de subnets privadas, se usado | Evitar NAT Gateway no desenho de demo quando possivel |

## Plano de Custos

Para a entrega, monte uma estimativa na AWS Pricing Calculator com:

- 1 cluster EKS.
- 1 node group com 1 a 2 instancias pequenas.
- 1 RDS PostgreSQL pequeno, se o grupo optar por RDS.
- 1 Load Balancer criado pelo ingress.
- Armazenamento EBS dos nodes e do banco.

Registre na apresentacao:

- Regiao usada.
- Tipo e quantidade de instancias.
- Se o banco foi RDS ou PostgreSQL dentro do cluster.
- Custo mensal estimado.
- Medidas de reducao de custo.

## Cleanup

```bash
cd micro_api_26.1
source infra/.env
infra/scripts/teardown.sh
```

Depois confira se nao sobrou recurso:

```bash
aws eks list-clusters --region $AWS_REGION
aws rds describe-db-instances --region $AWS_REGION
```
