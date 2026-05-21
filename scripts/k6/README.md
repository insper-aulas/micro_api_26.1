# k6 Load Tests

Run the local stack first:

```bash
docker compose up -d --build
```

Then execute a scenario:

```bash
k6 run scripts/k6/gateway-baseline.js
k6 run scripts/k6/gateway-stress.js
k6 run scripts/k6/order-create.js
```
