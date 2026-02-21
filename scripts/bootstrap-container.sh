#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/env.sh"

echo "[*] Starting container..."
podman start "$SANDBOX_CONTAINER_NAME"

echo "[*] Installing base system..."

podman exec -u root "$SANDBOX_CONTAINER_NAME" bash -c "

pacman-key --init
pacman-key --populate archlinux

pacman -Syu --noconfirm

pacman -S --noconfirm \
    sudo \
    neovim \
    tmux \
    git \
    base-devel \
    curl \
    wget \
    ripgrep \
    fd \
    python \
    python-pip \
    less \
    which \
    unzip

"

echo "[*] Creating user..."

podman exec -u root "$SANDBOX_CONTAINER_NAME" bash -c "

if ! id $SANDBOX_USER &>/dev/null; then
    useradd -m -u $SANDBOX_UID -s /bin/bash $SANDBOX_USER
fi

usermod -aG wheel $SANDBOX_USER

echo '%wheel ALL=(ALL:ALL) ALL' >> /etc/sudoers

mkdir -p $SANDBOX_HOME
chown -R $SANDBOX_USER:$SANDBOX_USER $SANDBOX_HOME

"

echo "[*] Setting default login user..."

podman exec -u root "$SANDBOX_CONTAINER_NAME" bash -c "
echo 'su - $SANDBOX_USER' >> /root/.bashrc
"

echo "[✓] Bootstrap complete"
echo
echo "Enter with:"
echo "  $SCRIPT_DIR/enter.sh"
