#!/usr/bin/env bash
# Run the green-defining test suite for a worktree and diff it against a baseline.
#   scripts/lit.sh <worktree> <build-dir> <jobs> <out-dir> [baseline-lit.json]
# Writes <out-dir>/lit.json (lit results), <out-dir>/unit.json (RISCVISAInfo gtest) and
# <out-dir>/lit_diff.json (lit_diff.py report). Exit status is lit_diff.py's (0 = green).
set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
source "$here/../config.env"
wt="$1"; bd="$2"; jobs="$3"; out="$4"; baseline="${5:-}"
mkdir -p "$out"
"$here/in-builder.sh" bash -c '
set -uo pipefail
wt="$1"; bd="$2"; jobs="$3"; out="$4"; shift 4
ninja -C "$bd" -j "$jobs" -k 0 llvm-test-depends clang-test-depends lld || exit 3
paths=(); for p in "$@"; do paths+=("$wt/$p"); done
"$bd/bin/llvm-lit" -q --no-progress-bar -j "$jobs" -o "$out/lit.json" "${paths[@]}"
# ISAInfo unit test lives in SupportTests (LLVM 18) or TargetParserTests (19+).
for t in TargetParserTests SupportTests; do
  if ninja -C "$bd" -j "$jobs" "$t" >/dev/null 2>&1; then
    bin=$(find "$bd/unittests" -type f -name "$t" | head -1)
    "$bin" --gtest_filter="RISCVISAInfo*" --gtest_output="json:$out/unit.json" >"$out/unit.log" 2>&1
    echo "unit ($t) exit $?"; break
  fi
done
exit 0
' _ "$wt" "$bd" "$jobs" "$out" $LIT_PATHS
rc=$?
[ $rc -ne 0 ] && { echo "lit.sh: building test dependencies failed ($rc)"; exit $rc; }
args=(--candidate "$out/lit.json" --fork-tests "$here/../data/fork-tests.txt" --out "$out/lit_diff.json"
      --known-failures "$here/../data/known-failures.txt")
[ -n "$baseline" ] && args+=(--baseline "$baseline")
python3 "$here/lit_diff.py" "${args[@]}"
