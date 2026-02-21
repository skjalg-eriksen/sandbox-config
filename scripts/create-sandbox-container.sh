#!/usr/bin/env bash
set -euo pipefail

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/env.sh"

echo "[*] Creating sandbox directories..."
mkdir -p "$SANDBOX_WORKSPACE"
mkdir -p "$SANDBOX_CACHE"

# Check existing container
if podman container exists "$SANDBOX_CONTAINER_NAME"; then
    echo "[!] Container already exists: $SANDBOX_CONTAINER_NAME"
    echo "Remove it with:"
    echo "  podman rm -f $SANDBOX_CONTAINER_NAME"
    exit 1
fi

echo "[*] Creating container..."

podman create \
  --name "$SANDBOX_CONTAINER_NAME" \
  --userns="$SANDBOX_USERNS" \
  --network="$SANDBOX_NETWORK" \
  --add-host="$SANDBOX_HOST_ALIAS" \
  --cap-drop=all \
  --security-opt=no-new-privileges \
  --pids-limit="$SANDBOX_PIDS" \
  --memory="$SANDBOX_MEMORY" \
  --cpus="$SANDBOX_CPUS" \
  -e HOME="$SANDBOX_HOME" \
  -v "$SANDBOX_WORKSPACE:$CONTAINER_WORKSPACE" \
  -v "$SANDBOX_CACHE:$CONTAINER_CACHE" \
  -w "$CONTAINER_WORKSPACE" \
  -it "$SANDBOX_IMAGE" \
  bash

echo "[✓] Container created: $SANDBOX_CONTAINER_NAME"
echo
echo "Next steps:"
echo "  podman start $SANDBOX_CONTAINER_NAME"
echo "  $SCRIPT_DIR/bootstrap-container.sh"
