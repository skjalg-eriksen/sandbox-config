#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/env.sh"

echo "[*] Creating directories..."
mkdir -p "$SANDBOX_WORKSPACE"
mkdir -p "$SANDBOX_CACHE"

echo "[*] Building container image..."

podman build \
  -t "$SANDBOX_IMAGE" \
  --build-arg USERNAME=$(whoami) \
  --build-arg UID=$(id -u) \
  "$SANDBOX_ROOT"

echo "[✓] Build complete"
