#!/usr/bin/env bash
# Run a GAP9 SDK ELF on GVSoC2 gap.gap9.evk the way the SDK's `run` target does
# (utils/cmake/macros.cmake:setup_gvsoc2_targets), with the out-of-tree gvsoc2.
#   run_app.sh <elf> [timeout seconds, default 300] [extra gvrun run args]
W=${SDK_CLANG_WORK:-/tmp/sdk-clang-work}
ELF=$(readlink -f "$1"); T=${2:-300}; shift; shift
WD=$(mktemp -d "$W/gvrun.XXXXXX")
cd "$WD"
timeout "$T" env -u PYTHONPATH PYTHONDONTWRITEBYTECODE=1 PATH=/home/ubuntu/gvsoc-venv/bin:$PATH \
  "$W/gvsoc2-install/bin/gvrun" --target=gap.gap9.evk --work-dir="$WD" \
  --parameter chip/binary="$ELF" run "$@"
rc=$?
echo "[run_app] exit code: $rc"
rm -rf "$WD"
exit $rc
