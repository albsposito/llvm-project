#!/usr/bin/env bash
# Back-end coverage table (report.md, question 4).
# For every backend/*.ll: llc -verify-machineinstrs, then print
#   file | status | packed (pv.*/vf*) mnemonics | number of non-packed instructions
# Output: out/backend.tsv and out/backend/<name>.{s,err}
set -u
here="$(cd "$(dirname "$0")" && pwd)"
LLC="${LLC:-/home/ubuntu/llvm-project/pulp-llvm-port/toolchains/port-20-bench/bin/llc}"
# Feature list = what clang -march=rv32imc_xgap9 puts in "target-features".
MATTR="${MATTR:-+m,+c,+xgap,+xpulpv,+xpulpfvec,+xpulpf16alt,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul}"
python3 "$here/gen_backend.py" "$here/backend" >/dev/null
mkdir -p "$here/out/backend"
tsv="$here/out/backend.tsv"; : > "$tsv"
for f in "$here"/backend/*.ll; do
  n=$(basename "$f" .ll)
  s="$here/out/backend/$n.s"; e="$here/out/backend/$n.err"
  timeout 60 "$LLC" -mtriple=riscv32-unknown-elf -mattr="$MATTR" -target-abi=ilp32 -O2 \
     -verify-machineinstrs "$f" -o "$s" >"$e" 2>&1
  rc=$?
  if [ $rc -ne 0 ]; then
    msg=$(grep -m1 -E "LLVM ERROR|Assertion|Cannot select|Bad machine code|UNREACHABLE|timeout" "$e" | cut -c1-150)
    [ $rc -eq 124 ] && msg="TIMEOUT (legalizer loop)"
    printf '%s\tCRASH\t%s\t-\n' "$n" "$msg" >> "$tsv"
    continue
  fi
  body=$(grep -E '^\s+[a-z]' "$s" | grep -vE '^\s+\.' )
  packed=$(echo "$body" | awk '{print $1}' | grep -E '^(pv\.|vf)' | sort | uniq -c | awk '{printf "%s%sx%s", (NR>1?" ":""), $2, $1}')
  calls=$(echo "$body" | grep -E '^\s+(call|tail|jal)\s' | awk '{print $2}' | sort -u | tr '\n' ' ')
  other=$(echo "$body" | awk '{print $1}' | grep -vE '^(pv\.|vf|ret$|c\.jr$)' | sort | uniq -c | awk '{printf "%s%sx%s", (NR>1?" ":""), $2, $1}')
  nother=$(echo "$body" | awk '{print $1}' | grep -cvE '^(pv\.|vf|ret$)')
  st=OK
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$n" "$st" "${packed:--}" "$nother" "${other:--}" "${calls:--}" >> "$tsv"
done
echo "wrote $tsv: $(wc -l < "$tsv") rows, $(grep -c CRASH "$tsv") crashes"
