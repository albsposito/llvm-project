#!/usr/bin/env bash
# Run a command inside the build container with PORT_ROOT bind-mounted at the same path.
#   scripts/in-builder.sh <cmd> [args...]
set -euo pipefail
source "$(dirname "$0")/../config.env"
mkdir -p "$CCACHE_DIR"
workdir="$PWD"
case "$workdir" in "$PORT_ROOT"*) ;; *) workdir="$PORT_ROOT" ;; esac
exec docker run --rm --init -u "$(id -u):$(id -g)" \
  -e HOME=/tmp -e CCACHE_DIR="$CCACHE_DIR" -e CCACHE_BASEDIR="$PORT_ROOT" \
  -v "$PORT_ROOT:$PORT_ROOT" -w "$workdir" "$BUILDER_IMAGE" "$@"
