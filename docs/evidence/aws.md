# Evidencias AWS

## Console de custo e uso

O grupo utilizou uma conta AWS compartilhada para a infraestrutura do projeto. O console AWS mostrou consumo ativo no mes da entrega.

| Campo | Valor observado |
| --- | --- |
| Regiao selecionada | South America (Sao Paulo) / `sa-east-1` |
| Custo do mes atual | `US$ 385,40` |
| Previsao para final do mes | `US$ 393,13` |
| Categorias visiveis | Elastic Container Service for Kubernetes, Relational Database Service, EC2 - Other, MQ, Tax e Outros |

## Print esperado

Salvar o print do console em:

```text
docs/evidence/screenshots/aws-cost-and-usage.png
```

## Evidencias ainda recomendadas

- Tela do cluster EKS.
- `kubectl get nodes`.
- `kubectl -n store-platform get pods`.
- `kubectl -n store-platform get svc,ingress`.
- Tela do Jenkins com pipeline verde.
- Teste de carga mostrando HPA escalando.
