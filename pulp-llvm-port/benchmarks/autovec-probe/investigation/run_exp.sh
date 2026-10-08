#!/usr/bin/env bash
# Experiment (report.md, question 3 and 6): what the vectorizers do once the
# target claims a 32-bit vector register.
#
# Needs an EXPERIMENTAL opt built from integration head 26e7268c3127 plus
# exp-tti.patch (6 lines in RISCVTargetTransformInfo.{h,cpp}; NOT a proposed
# fix, see the report). Point EXP_OPT at it. Everything else is the stock
# port-20-bench toolchain.
#
#   run_exp.sh <name> [extra opt flags...]      e.g. run_exp.sh base
#   MATTR_EXTRA=,+unaligned-scalar-mem run_exp.sh ualign
# Output: out/exp/<name>/<file>.{O0.ll,opt.ll,s,remarks.txt,llc.err}
set -u
here="$(cd "$(dirname "$0")" && pwd)"
T=/home/ubuntu/llvm-project/pulp-llvm-port/toolchains/port-20-bench/bin
EXP_OPT="${EXP_OPT:?set EXP_OPT to the experimental opt}"
LLC="${LLC:-$T/llc}"
EXTRACT="${EXTRACT:-/home/ubuntu/llvm-project/pulp-llvm-port/build/int-20/bin/llvm-extract}"
F="--target=riscv32-unknown-elf -march=rv32imc_xgap9 -mPE=8 -mabi=ilp32"
name="$1"; shift
d="$here/out/exp/$name"; mkdir -p "$d"
for src in ${SRCS:-loops2 loops_f16}; do
  "$T/clang" $F -O3 -S -emit-llvm -Xclang -disable-llvm-passes "$here/$src.c" -o "$d/$src.O0.ll" || exit 1
  if [ -n "${MATTR_EXTRA:-}" ]; then   # add a subtarget feature to every function
    sed -i "s/\"target-features\"=\"/\"target-features\"=\"${MATTR_EXTRA#,},/" "$d/$src.O0.ll"
  fi
  # With any loop-vectorize remark option the experimental opt asserts in
  # VPReductionRecipe::computeCost (emitInvalidCostRemarks) on the ordered-fadd
  # loop dot_f16: generic LLVM 20 remark-emission bug, see report section 3.
  # So on failure the run is repeated without remark options.
  "$EXP_OPT" -passes='default<O3>' "$@" -pass-remarks='loop-vectorize|slp-vectorizer' \
     -pass-remarks-missed='loop-vectorize|slp-vectorizer' \
     "$d/$src.O0.ll" -S -o "$d/$src.opt.ll" 2> "$d/$src.remarks.txt"
  rc=$?
  if [ $rc -ne 0 ]; then
    echo "$src: opt with remarks FAILED rc=$rc ($(grep -m1 -oE 'Assertion .*failed' "$d/$src.remarks.txt" | cut -c1-90)); retrying without remarks"
    mv "$d/$src.remarks.txt" "$d/$src.remarks-crash.txt"
    "$EXP_OPT" -passes='default<O3>' "$@" "$d/$src.O0.ll" -S -o "$d/$src.opt.ll" 2> "$d/$src.remarks.txt" || { echo "$src: opt FAILED"; continue; }
  fi
  # llc one function at a time, so one back-end crash does not hide the rest
  : > "$d/$src.s"; : > "$d/$src.status.tsv"
  for fn in $(grep -oE '^define [^@]*@[A-Za-z0-9_]+' "$d/$src.opt.ll" | sed 's/.*@//'); do
    "$EXTRACT" --func="$fn" -S "$d/$src.opt.ll" -o "$d/$src.$fn.ll" 2>/dev/null
    vec=$(grep -oE '<[0-9]+ x (i8|i16|i32|half|i1)>' "$d/$src.$fn.ll" | sort -u | tr '\n' ' ')
    if "$LLC" -O3 -verify-machineinstrs "$d/$src.$fn.ll" -o "$d/$src.$fn.s" 2> "$d/$src.$fn.llc.err"; then
      st=ok; cat "$d/$src.$fn.s" >> "$d/$src.s"; rm -f "$d/$src.$fn.llc.err" "$d/$src.$fn.ll" "$d/$src.$fn.s"
    else
      st="CRASH: $(grep -m1 -E 'Assertion|LLVM ERROR|Bad machine' "$d/$src.$fn.llc.err" | sed -E 's/.*(Assertion|LLVM ERROR)/\1/' | cut -c1-110)"
    fi
    printf '%s\t%s\t%s\n' "$fn" "${vec:--}" "$st" >> "$d/$src.status.tsv"
  done
  echo "$src: $(grep -c . "$d/$src.status.tsv") functions, $(grep -vc -P '\t-\t' "$d/$src.status.tsv") with vector IR, $(grep -c CRASH "$d/$src.status.tsv") llc crashes, packed insns: $(grep -cE '^\s+(pv\.|vf)' "$d/$src.s")"
done
