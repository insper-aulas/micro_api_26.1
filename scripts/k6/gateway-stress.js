import http from "k6/http";
import { check, sleep } from "k6";

const baseUrl = __ENV.BASE_URL || "http://localhost:8085";

export const options = {
  stages: [
    { duration: "30s", target: 20 },
    { duration: "1m", target: 50 },
    { duration: "30s", target: 0 },
  ],
};

export default function () {
  const response = http.get(`${baseUrl}/products`);

  check(response, {
    "gateway returned a valid status": (res) => res.status < 500,
  });

  sleep(1);
}
