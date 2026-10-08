#!/usr/bin/env bash
# Per-loop summary of the loop vectorizer's cost decision with the experimental opt:
#   function | scalar cost | "VF: total (per lane)" ... | chosen VF | remark
# usage: EXP_OPT=... lv_costs.sh out/exp/base/loops2.O0.ll
set -u
X="${EXTRACT:-/home/ubuntu/llvm-project/pulp-llvm-port/build/int-20/bin/llvm-extract}"
tmp=$(mktemp -d)
for fn in $(grep -oE '^define [^@]*@[A-Za-z0-9_]+' "$1" | sed 's/.*@//'); do
  "$X" --func="$fn" -S "$1" -o "$tmp/one.ll" 2>/dev/null
  "$EXP_OPT" -passes='default<O3>' -debug-only=loop-vectorize "$tmp/one.ll" -S -o /dev/null > "$tmp/dbg.txt" 2>&1
  sc=$(grep -m1 -oE 'Scalar loop costs: [0-9]+' "$tmp/dbg.txt" | grep -oE '[0-9]+$')
  vf=$(grep -oE 'Cost for VF [0-9]+: [0-9]+ \(Estimated cost per lane: [0-9.]+\)' "$tmp/dbg.txt" | sort -u | sed -E 's/Cost for VF ([0-9]+): ([0-9]+) \(Estimated cost per lane: ([0-9.]+)\)/VF\1=\2 (\3\/lane)/' | tr '\n' ';')
  sel=$(grep -m1 -oE 'LV: Selecting VF: [0-9]+|LV: Vectorization is possible but not beneficial|LV: Not vectorizing[^.]*' "$tmp/dbg.txt" | head -1)
  why=$(grep -m1 -oE 'LV: Not vectorizing: .*|LV: Interleaving .*|loop not vectorized: .*' "$tmp/dbg.txt" | cut -c1-90)
  printf '%s\t%s\t%s\t%s\t%s\n' "$fn" "${sc:--}" "${vf:--}" "${sel:--}" "${why:--}"
done
rm -rf "$tmp"
