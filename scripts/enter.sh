#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/env.sh"

if ! podman container exists "$SANDBOX_NAME"; then
    echo "[*] Creating persistent container..."

    podman create \
        --name "$SANDBOX_NAME" \
        --network slirp4netns:allow_host_loopback=true \
        --cap-drop=all \
        --security-opt=no-new-privileges \
        -v "$SANDBOX_WORKSPACE:$CONTAINER_WORKSPACE" \
        -v "$SANDBOX_CACHE:$CONTAINER_CACHE" \
        "$SANDBOX_IMAGE"
fi

echo "[*] Starting container..."
podman start -ai "$SANDBOX_NAME"
