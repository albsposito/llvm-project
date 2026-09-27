#!/usr/bin/env bash
# Usage: run_sim.sh <elf> [extra gvrun args...]
# Runs a bare-metal ELF on the GVSoC2 ri5ky_testbench target, prints its
# output and the exit code, and returns that exit code.
set -uo pipefail
if [ $# -lt 1 ]; then echo "usage: $0 <elf> [gvrun args]" >&2; exit 2; fi
ELF=$(readlink -f "$1"); shift
SDK=${SDK:-/home/ubuntu/gap_sdk_release}
VENV=${VENV:-/home/ubuntu/gvsoc-venv}
P=$SDK/install/gvsoc2
WORK=$(mktemp -d "${TMPDIR:-/tmp}/run_sim.XXXXXX")
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"
env -u PYTHONPATH USE_GVRUN=1 USE_GVRUN2=1 PATH="$VENV/bin:$PATH" \
  "$P/bin/gvrun" --target=ri5ky_testbench --work-dir="$WORK" \
        --parameter soc/binary="$ELF" "$@" run 2>&1 | tee "$WORK/log"
rc=${PIPESTATUS[0]}
# gvrun maps a non-zero program exit to status 1 and prints
# "Platform returned an error (exitcode: N)"; recover N.
if [ $rc -ne 0 ]; then
  n=$(sed -n 's/.*Platform returned an error (exitcode: \([0-9-]*\)).*/\1/p' "$WORK/log" | tail -1)
  [ -n "$n" ] && rc=$n
fi
echo "[run_sim] exit code: $rc"
exit $rc
