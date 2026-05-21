import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  vus: 5,
  duration: "30s",
};

export default function () {
  const response = http.get("http://localhost:8085/");

  check(response, {
    "gateway is healthy": (res) => res.status === 200,
  });

  sleep(1);
}
