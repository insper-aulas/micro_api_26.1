# Load Testing

Os testes de carga ficam em `scripts/k6`.

## Objetivo

Os testes de carga foram usados para observar como a plataforma responde sob acessos simultaneos e para apoiar a validacao de HPA no ambiente Kubernetes. No caso do servico individual do Raphael, tambem foi gravado um Load Test especifico do `exchange-service`.

Video do Load Test do `exchange-service`: <https://youtu.be/LTDJSoIG2sQ>

## Cenarios

- `gateway-baseline.js`: small steady traffic against the gateway health endpoint.
- `gateway-stress.js`: ramping traffic against product listing through the gateway.
- `order-create.js`: creates products and orders to exercise cross-service behavior.

## Cenario individual: `exchange-service`

O teste individual exercita:

- `GET /`, para verificar saude do servico;
- `GET /exchanges/USD/BRL`, com header `id-account`;
- validacao de status HTTP `200`;
- validacao de campos de resposta `buy` e `sell`.

Configuracao usada no roteiro do video:

| Campo | Valor |
| --- | --- |
| Ferramenta | k6 |
| Servico | `exchange-service` |
| URL local | `http://localhost:8000` |
| Usuarios virtuais | 10 VUs |
| Duracao | 30s |
| Limite de falhas esperado | menor que 5% |
| Latencia esperada | p95 abaixo de 1.5s |

Comando:

```bash
uvicorn app.main:app --reload --port 8000
k6 run scripts/k6/exchange-load.js
```

## Execucao local da stack

```bash
docker compose up -d --build
k6 run scripts/k6/gateway-baseline.js
```

## EKS com HPA

O cenario de HPA deve ser executado contra o DNS publico do ingress controller:

```bash
export BASE_URL=http://DNS_DO_LOAD_BALANCER
kubectl -n store-platform get hpa
kubectl -n store-platform get pods -l app=gateway-service
```

Em uma janela, monitore o HPA:

```bash
watch -n 1 'kubectl -n store-platform get hpa'
```

Em outra janela, monitore os pods:

```bash
watch -n 1 'kubectl -n store-platform get pods -l app=gateway-service'
```

Em uma terceira janela, gere carga:

```bash
k6 run -e BASE_URL=$BASE_URL scripts/k6/gateway-stress.js
```

Caso o k6 local nao gere CPU suficiente, use um gerador dentro do cluster:

```bash
kubectl -n store-platform run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://gateway-service:8085/products; done"
```

Evidencias para salvar:

- `kubectl -n store-platform get hpa` antes, durante e depois.
- `kubectl -n store-platform get pods -l app=gateway-service` mostrando replicas novas.
- Saida final do `k6`.
- Video de 2 a 3 minutos com monitoramento, geracao de carga e resultado final.

## Leitura dos resultados

Ao analisar a saida do k6, os principais campos sao:

| Metrica | O que indica |
| --- | --- |
| `http_req_failed` | percentual de requisicoes com erro |
| `http_req_duration` | tempo total de resposta das requisicoes |
| `p(95)` | tempo abaixo do qual 95% das requisicoes responderam |
| `checks_succeeded` | percentual de validacoes que passaram |

Para a entrega, o mais importante e mostrar que a API continua respondendo, que os checks passam e que os tempos de resposta ficam coerentes para o cenario testado.
