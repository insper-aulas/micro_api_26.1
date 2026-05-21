import http from "k6/http";
import { check } from "k6";

export const options = {
  vus: 3,
  iterations: 10,
};

export default function () {
  const productPayload = JSON.stringify({
    name: `Tomato ${__VU}-${__ITER}`,
    price: 10.12,
    unit: "kg",
  });

  const headers = {
    "Content-Type": "application/json",
    "id-account": "load-test-account",
  };

  const product = http.post("http://localhost:8080/products", productPayload, { headers });

  check(product, {
    "product created": (res) => res.status === 201,
  });

  const productId = product.json("id");
  const orderPayload = JSON.stringify({
    items: [{ idProduct: productId, quantity: 2 }],
  });

  const order = http.post("http://localhost:8081/orders", orderPayload, { headers });

  check(order, {
    "order created": (res) => res.status === 201,
  });
}
