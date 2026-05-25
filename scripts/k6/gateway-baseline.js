import http from "k6/http";
import { check, sleep } from "k6";

const baseUrl = __ENV.BASE_URL || "http://localhost:8085";

export const options = {
  vus: 5,
  duration: "30s",
};

export default function () {
  const response = http.get(`${baseUrl}/`);

  check(response, {
    "gateway is healthy": (res) => res.status === 200,
  });

  sleep(1);
}
