#!/usr/bin/env bash
# Run a prebuilt ELF (e.g. prebuilt/board/t6_kernels.clang-O2.elf) on the board with the local
# SDK's normal `run` target. The SDK first builds a placeholder app (common/runner) for your
# board config, then its ELF is replaced by the prebuilt one before loading.
#   scripts/run_prebuilt.sh <elf> [log name]
# Output: results/<log name>.log (default: the ELF name without .elf, prefixed "prebuilt.").
set -o pipefail
[ $# -ge 1 ] || { sed -n 2,7p "$0"; exit 2; }
source "$(dirname "$0")/lib.sh"; pack_need_sdk
E=$1; N=${2:-prebuilt.$(basename "$E" .elf)}
pack_prebuilt "$N" "$E"
