#!/usr/bin/env bash

export SANDBOX_NAME="sandbox-dev"
export SANDBOX_IMAGE="sandbox-arch"

export SANDBOX_ROOT="$HOME/sandbox"
export SANDBOX_WORKSPACE="$SANDBOX_ROOT/workspace"
export SANDBOX_CACHE="$SANDBOX_ROOT/cache"

export CONTAINER_WORKSPACE="/workspace"
export CONTAINER_CACHE="/cache"

export SANDBOX_NIX_CONFIG="$SANDBOX_ROOT/nix"
export CONTAINER_NIX_CONFIG="/sandbox-nix"

export SANDBOX_NIX_STORE="$SANDBOX_CACHE/nix"
export CONTAINER_NIX_STORE="/nix"
