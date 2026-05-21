#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${ROOT_DIR}/bin"
KIND_BIN="${BIN_DIR}/kind"

OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "${ARCH}" in
  x86_64)
    ARCH="amd64"
    ;;
  arm64|aarch64)
    ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: ${ARCH}" >&2
    exit 1
    ;;
esac

mkdir -p "${BIN_DIR}"

LATEST_TAG="$(curl -fsSL https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])')"
DOWNLOAD_URL="https://kind.sigs.k8s.io/dl/${LATEST_TAG}/kind-${OS}-${ARCH}"

curl -fsSL "${DOWNLOAD_URL}" -o "${KIND_BIN}"
chmod +x "${KIND_BIN}"

echo "Installed kind ${LATEST_TAG} at ${KIND_BIN}"
