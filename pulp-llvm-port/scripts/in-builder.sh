#!/usr/bin/env bash
# Run a command inside the build container (or natively when BUILDER_IMAGE is empty) with PORT_ROOT bind-mounted at the same path.
#   scripts/in-builder.sh <cmd> [args...]
set -euo pipefail
source "$(dirname "$0")/../config.env"
mkdir -p "$CCACHE_DIR"
if [ -z "${BUILDER_IMAGE:-}" ]; then
  # Native build: same environment the container sets.
  export CCACHE_DIR CCACHE_BASEDIR="$PORT_ROOT" CCACHE_COMPILERCHECK=content CCACHE_NOHASHDIR=true CCACHE_MAXSIZE=80G
  exec "$@"
fi
workdir="$PWD"
case "$workdir" in "$PORT_ROOT"*) ;; *) workdir="$PORT_ROOT" ;; esac
exec docker run --rm --init -u "$(id -u):$(id -g)" \
  -e HOME=/tmp -e CCACHE_DIR="$CCACHE_DIR" -e CCACHE_BASEDIR="$PORT_ROOT" \
  -v "$PORT_ROOT:$PORT_ROOT" -w "$workdir" "$BUILDER_IMAGE" "$@"
