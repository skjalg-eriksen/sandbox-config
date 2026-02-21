#!/usr/bin/env bash
# ============================================
# Sandbox Environment Configuration
# Single source of truth for container setup
# ============================================

# Container identity
export SANDBOX_CONTAINER_NAME="sandbox-dev"
export SANDBOX_IMAGE="docker.io/library/archlinux:latest"
export SANDBOX_USERNS="private"

# Container user
export SANDBOX_USER="hugin"
export SANDBOX_HOME="/home/$SANDBOX_USER"
export SANDBOX_UID=1000

# Host paths
export SANDBOX_ROOT="$HOME/sandbox"
export SANDBOX_WORKSPACE="$SANDBOX_ROOT/workspace"
export SANDBOX_CACHE="$SANDBOX_ROOT/cache"

# Container mount points
export CONTAINER_WORKSPACE="/workspace"
export CONTAINER_CACHE="/cache"

# Resource limits
export SANDBOX_MEMORY="16g"
export SANDBOX_CPUS="8"
export SANDBOX_PIDS="512"

# Network
export SANDBOX_NETWORK="slirp4netns:allow_host_loopback=true"
export SANDBOX_HOST_ALIAS="host.containers.internal:host-gateway"
