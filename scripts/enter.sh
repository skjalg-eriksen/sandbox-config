#!/usr/bin/env bash
set -euo pipefail

# Resolve symlink to real script location
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

source "$SCRIPT_DIR/env.sh"

# Ensure host-side nix store exists and is writable (prevents nix "chroot store" fallback)
mkdir -p "$SANDBOX_NIX_STORE/store" \
         "$SANDBOX_NIX_STORE/var/nix" \
         "$SANDBOX_NIX_STORE/var/nix/profiles/per-user/$(id -un)"

# Make sure your user owns it (rootless container user == host user with keep-id)
chown -R "$(id -u)":"$(id -g)" "$SANDBOX_NIX_STORE"
chmod 0755 "$SANDBOX_NIX_STORE" "$SANDBOX_NIX_STORE/store" "$SANDBOX_NIX_STORE/var" "$SANDBOX_NIX_STORE/var/nix"

# Create container if it doesn't exist
if ! podman container exists "$SANDBOX_NAME"; then
    echo "[*] Creating container..."

    podman create \
        -it \
        --name "$SANDBOX_NAME" \
        --userns=keep-id \
        --network slirp4netns:allow_host_loopback=true \
        --cap-drop=all \
        --security-opt=no-new-privileges \
        -v "$SANDBOX_NIX_STORE:$CONTAINER_NIX_STORE" \
        -v "$SANDBOX_NIX_CONFIG:$CONTAINER_NIX_CONFIG" \
        -v "$SANDBOX_WORKSPACE:$CONTAINER_WORKSPACE" \
        -v "$SANDBOX_CACHE:$CONTAINER_CACHE" \
        -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
        -e SSH_AUTH_SOCK="$SSH_AUTH_SOCK" \
        "$SANDBOX_IMAGE"
fi

# Check container state
STATE="$(podman inspect -f '{{.State.Status}}' "$SANDBOX_NAME")"

case "$STATE" in
    running)
        echo "[*] Attaching to running container..."
        exec podman exec -it "$SANDBOX_NAME" bash -lc "nix develop $CONTAINER_NIX_CONFIG"
        ;;
    exited|created|configured)
        echo "[*] Starting container..."
        podman start "$SANDBOX_NAME" >/dev/null
        exec podman exec -it "$SANDBOX_NAME" bash -lc "nix develop $CONTAINER_NIX_CONFIG"
        ;;
    *)
        echo "[!] Unknown container state: $STATE"
        exit 1
        ;;
esac
