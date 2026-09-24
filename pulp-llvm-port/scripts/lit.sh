#!/usr/bin/env bash
# Run the green-defining test suite for a worktree and diff it against a baseline.
#   scripts/lit.sh <worktree> <build-dir> <jobs> <out-dir> [baseline-lit.json] [baseline-renames.json]
# Writes <out-dir>/lit.json (lit results), <out-dir>/unit.json (RISCVISAInfo gtest) and
# <out-dir>/lit_diff.json (lit_diff.py report). Exit status is lit_diff.py's (0 = green).
set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
source "$here/../config.env"
wt="$1"; bd="$2"; jobs="$3"; out="$4"; baseline="${5:-}"; renames="${6:-}"
mkdir -p "$out"
# Remove prior evidence before any command can fail.
rm -f "$out/lit.json" "$out/unit.json" "$out/unit.exit" "$out/lit_diff.json"
"$here/in-builder.sh" bash -c '
set -uo pipefail
wt="$1"; bd="$2"; jobs="$3"; out="$4"; shift 4
ninja -C "$bd" -j "$jobs" -k 0 llvm-test-depends clang-test-depends lld || exit 3
paths=(); for p in "$@"; do paths+=("$wt/$p"); done
"$bd/bin/llvm-lit" -q --no-progress-bar -j "$jobs" -o "$out/lit.json" "${paths[@]}"
# ISAInfo unit test lives in SupportTests (LLVM 18) or TargetParserTests (19+). Pick by
# where the test source is: both binaries exist at 18, and the wrong one runs 0 tests.
if [ -f "$wt/llvm/unittests/TargetParser/RISCVISAInfoTest.cpp" ]; then t=TargetParserTests; src=TargetParser; else t=SupportTests; src=Support; fi
ninja -C "$bd" -j "$jobs" "$t" >/dev/null 2>&1 || { echo "unit: building $t failed"; exit 4; }
bin=$(find "$bd/unittests" -type f -name "$t" | head -1)
# The suites in RISCVISAInfoTest.cpp are named after what they test (ParseArchString, ...),
# not after the file, so build the filter from the file itself.
filter=$(grep -oE "^TEST(_F)?\(\w+" "$wt/llvm/unittests/$src/RISCVISAInfoTest.cpp" | sed "s/.*(//; s/$/.*/" | sort -u | paste -sd:)
"$bin" --gtest_filter="$filter" --gtest_output="json:$out/unit.json" >"$out/unit.log" 2>&1
urc=$?
printf "%s\n" "$urc" > "$out/unit.exit"
n=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1]))[\"tests\"])" "$out/unit.json" 2>/dev/null || echo 0)
echo "unit ($t) exit $urc, $n tests"
[ "$urc" -eq 0 ] && [ "$n" -gt 0 ] || exit 5
exit 0
' _ "$wt" "$bd" "$jobs" "$out" $LIT_PATHS
rc=$?
[ $rc -eq 3 ] && { echo "lit.sh: building test dependencies failed ($rc)"; exit $rc; }
[ $rc -ne 0 ] && echo "lit.sh: RISCVISAInfo unit tests failed or did not run ($rc), see $out/unit.log"
urc=$(cat "$out/unit.exit" 2>/dev/null || echo 99)
args=(--candidate "$out/lit.json" --fork-tests "$here/../data/fork-tests.txt" --out "$out/lit_diff.json"
      --known-failures "$here/../data/known-failures.txt"
      --unit "$out/unit.json" --unit-exit "$urc")
[ -n "$baseline" ] && args+=(--baseline "$baseline")
[ -n "$renames" ] && args+=(--baseline-renames "$renames")
python3 "$here/lit_diff.py" "${args[@]}"
