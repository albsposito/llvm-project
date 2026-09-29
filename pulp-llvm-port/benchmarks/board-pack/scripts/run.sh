#!/usr/bin/env bash
# Build one board-pack test from source with the local SDK and run it on the board
# (SDK `run` target: loads the ELF over JTAG and prints the program output).
#   scripts/run.sh <test dir> [log name] [extra cmake -D options...]
# Output: results/<log name>.log (default log name = test dir name).
# PACK_PLATFORM=gvsoc runs it on the SDK's GVSoC instead.
set -o pipefail
[ $# -ge 1 ] || { sed -n 2,6p "$0"; exit 2; }
source "$(dirname "$0")/lib.sh"; pack_need_sdk
T=$(cd "$1" && pwd); N=${2:-$(basename "$T")}; shift; [ $# -gt 0 ] && shift
pack_test "$N" "$T" "$@"
