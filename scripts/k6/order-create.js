import http from "k6/http";
import { check } from "k6";

const productUrl = __ENV.PRODUCT_URL || "http://localhost:8080";
const orderUrl = __ENV.ORDER_URL || "http://localhost:8081";

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

  const product = http.post(`${productUrl}/products`, productPayload, { headers });

  check(product, {
    "product created": (res) => res.status === 201,
  });

  const productId = product.json("id");
  const orderPayload = JSON.stringify({
    items: [{ idProduct: productId, quantity: 2 }],
  });

  const order = http.post(`${orderUrl}/orders`, orderPayload, { headers });

  check(order, {
    "order created": (res) => res.status === 201,
  });
}
