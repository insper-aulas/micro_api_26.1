# Load Testing

Os testes de carga ficam em `scripts/k6`.

Video de Load Test: <https://youtu.be/LTDJSoIG2sQ>

## Scenarios

- `gateway-baseline.js`: small steady traffic against the gateway health endpoint.
- `gateway-stress.js`: ramping traffic against product listing through the gateway.
- `order-create.js`: creates products and orders to exercise cross-service behavior.

## Local

```bash
docker compose up -d --build
k6 run scripts/k6/gateway-baseline.js
```

## EKS com HPA

O enunciado pede um video mostrando o teste de carga e o HPA escalando. Para isso, rode contra o DNS publico do ingress controller:

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
- Video de 2 a 3 minutos com as tres janelas.

Evidencia em video publicada: <https://youtu.be/LTDJSoIG2sQ>
