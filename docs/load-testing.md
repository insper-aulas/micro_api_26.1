# Load Testing

Load tests are stored in `scripts/k6`.

## Scenarios

- `gateway-baseline.js`: small steady traffic against the gateway health endpoint.
- `gateway-stress.js`: ramping traffic against product listing through the gateway.
- `order-create.js`: creates products and orders to exercise cross-service behavior.

## Run

```bash
docker compose up -d --build
k6 run scripts/k6/gateway-baseline.js
```
