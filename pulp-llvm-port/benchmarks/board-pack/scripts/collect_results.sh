#!/usr/bin/env bash
# Collect every results/*.log plus the environment into ONE text file to send back:
#   results/board-results-<UTC date>.txt
# It also prints a summary: VERDICT lines, CHECK FAIL lines (= differs from the simulator),
# tests without an end marker, the test-6 clang/GCC cycle table, and a line-by-line comparison
# of every RESULT/CHECK/VERDICT line with the simulator's (sim-results/).
set -o pipefail
source "$(dirname "$0")/lib.sh"
# Lines compared with the simulator: RESULT/CHECK/VERDICT without cycle counts (those differ by
# design), and the per-core Hello/Perf lines of the SDK examples, sorted (their order varies).
pack_cmp_lines() {
  grep -E '^(RESULT|CHECK|VERDICT)' "$1" | grep -v 'cycles'
  grep -E '^\[[0-9]+ [0-9]+\] (Hello|Perf)' "$1" | sed 's/Perf : [0-9]* cycles/Perf : N cycles/' | sort
}
OUTF=$RESULTS/board-results-$(date -u +%Y%m%d-%H%M%S).txt
{
  echo "######## GAP9 board-pack results"
  echo "date (UTC): $(date -u)"
  echo "host: $(uname -a)"
  echo "pack: $(cd "$PACK" && git rev-parse --short HEAD 2>/dev/null || echo 'not a git checkout') $(grep -m1 PACK_VERSION "$PACK/common/pack.h" | awk '{print $3}')"
  echo "GAP_SDK_HOME: ${GAP_SDK_HOME:-unset}  version: $(cat "${GAP_SDK_HOME:-/nonexistent}/sdk_version" 2>/dev/null | head -1)"
  echo "SDK git: $(git -C "${GAP_SDK_HOME:-/nonexistent}" describe --always --tags 2>/dev/null)"
  echo "board config: TARGET_CHIP=${TARGET_CHIP:-?} BOARD_NAME=${BOARD_NAME:-?} GAP_TARGET=${GAP_TARGET:-?}"
  echo "gcc: $(riscv32-unknown-elf-gcc --version 2>/dev/null | head -1)"
  echo "clang: $("${GAP_CLANG_ROOT:-/nonexistent}/bin/clang" --version 2>/dev/null | head -1)"
  echo "platform: $PLATFORM"
  echo
  echo "######## SUMMARY"
  for f in "$RESULTS"/*.log; do
    [ -e "$f" ] || continue
    case $f in *.build-failed.log) continue;; esac
    n=$(basename "$f" .log)
    p=$(grep -c '^CHECK .* PASS' "$f"); x=$(grep -c '^CHECK .* FAIL' "$f")
    end=$(grep -m1 '^=== END \|^Bye !\|^Done\.' "$f" >/dev/null && echo ok || echo "NO END MARKER (hang/crash/timeout?)")
    printf '%-40s CHECK pass=%-3s fail=%-3s end=%s\n' "$n" "$p" "$x" "$end"
  done
  echo
  echo "######## VERDICT lines"
  grep -H '^VERDICT' "$RESULTS"/*.log 2>/dev/null | sed "s|$RESULTS/||"
  echo
  echo "######## CHECK FAIL lines (FAIL = differs from the simulator result, except where the test says otherwise)"
  grep -H '^CHECK .* FAIL' "$RESULTS"/*.log 2>/dev/null | sed "s|$RESULTS/||"
  echo
  echo "######## test 6: clang vs GCC cycles on this platform"
  ls "$RESULTS"/*t6_kernels.*.log >/dev/null 2>&1 && python3 "$PACK/scripts/compare_t6.py" "$RESULTS"/*t6_kernels.*.log 2>&1
  echo
  echo "######## difference to the simulator (sim-results/, same program, GVSoC2 gap.gap9.evk)"
  for f in "$RESULTS"/*.log; do
    n=$(basename "$f" .log); s=$PACK/sim-results/${n#prebuilt.}.log
    [ -e "$s" ] || continue
    d=$(diff <(pack_cmp_lines "$s") <(pack_cmp_lines "$f"))
    if [ -z "$d" ]; then echo "$n: same values as the simulator (cycle counts not compared)"; else echo "$n: DIFFERS from the simulator:"; echo "$d" | sed 's/^/    /'; fi
  done
  echo
  for f in "$RESULTS"/*.log; do
    echo "######## FILE $(basename "$f")"
    cat "$f"
    echo
  done
} > "$OUTF" 2>&1
sed -n '/######## SUMMARY/,/######## test 6/p' "$OUTF" | head -80
echo
echo "==> send back this file: $OUTF"
