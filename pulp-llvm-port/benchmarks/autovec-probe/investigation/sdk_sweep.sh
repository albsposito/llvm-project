#!/usr/bin/env bash
# B156, risk estimate: what would change in the SDK's DSP library (public
# gap_sdk, tools/autotiler_v3/BasicKernels/DSP_Libraries, 35 files) if the
# vectorizers were switched on. Static only (no simulation).
# For every .c: clang -O3 front end, target feature unaligned-scalar-mem added
# to BOTH sides (so the difference is the vectorizers only) -> (a) stock opt,
# (b) experimental opt -> stock llc. Reports loops vectorized, crashes, and the
# functions whose code changed.
#   EXP_OPT=... sdk_sweep.sh        -> out/sdk/summary.tsv, out/sdk/functions.tsv
set -u
here="$(cd "$(dirname "$0")" && pwd)"
P=/home/ubuntu/llvm-project/pulp-llvm-port; T=$P/toolchains/port-20-bench/bin
EXP_OPT="${EXP_OPT:?}"
SDK=/home/ubuntu/gap_sdk_release; AT=$SDK/tools/autotiler_v3; DSP=$AT/BasicKernels/DSP_Libraries
K=$P/benchmarks/dsp-bench/sdk-kernels
CF="--target=riscv32-unknown-elf -march=rv32imc_xgap9 -mPE=8 -mabi=ilp32 -mno-relax -isystem /home/ubuntu/gap_riscv_toolchain_ubuntu/riscv32-unknown-elf/include -ffp-contract=fast"
SF="-std=gnu99 -fcommon -fno-jump-tables -fno-delete-null-pointer-checks -fomit-frame-pointer -ffunction-sections -fdata-sections -funsigned-char -w"
INC="-I$K/shim -I$DSP -I$DSP/FastMathFunctions -I$DSP/TransformFunctions/LUT_Tables -I$AT/Emulation -D__GAP9__"
d="$here/out/sdk"; mkdir -p "$d"; : > "$d/summary.tsv"; : > "$d/functions.tsv"
one() {
  f="$1"; n=$(basename "$f" .c)
  "$T/clang" $CF $SF $INC -O3 -S -emit-llvm -Xclang -disable-llvm-passes "$f" -o "$d/$n.O0.ll" 2> "$d/$n.fe.err" || { printf '%s\tFRONTEND-FAIL\n' "$n"; return; }
  sed 's/"target-features"="/"target-features"="+unaligned-scalar-mem,/' "$d/$n.O0.ll" > "$d/$n.O0u.ll"
  "$T/opt" -passes='default<O3>' "$d/$n.O0u.ll" -o "$d/$n.stock.bc" 2>/dev/null
  "$T/llc" -O3 "$d/$n.stock.bc" -o "$d/$n.stock.s" 2> "$d/$n.stock.err"; s1=$?
  "$EXP_OPT" -passes='default<O3>' -pass-remarks='loop-vectorize|slp-vectorizer' "$d/$n.O0u.ll" -o "$d/$n.exp.bc" 2> "$d/$n.exp.remarks"; o2=$?
  if [ $o2 -ne 0 ]; then   # remark-emission crash: retry without remarks
    "$EXP_OPT" -passes='default<O3>' "$d/$n.O0u.ll" -o "$d/$n.exp.bc" 2> "$d/$n.exp.opt.err"; o2=$?
  fi
  "$T/llc" -O3 "$d/$n.exp.bc" -o "$d/$n.exp.s" 2> "$d/$n.exp.err"; s2=$?
  lv=$(grep -c 'vectorized loop' "$d/$n.exp.remarks"); slp=$(grep -ciE 'SLP vectorized|Stores SLP vectorized|Vectorized horizontal' "$d/$n.exp.remarks")
  err=""; [ $o2 -ne 0 ] && err="opt: $(grep -m1 -oE 'Assertion .{0,90}|LLVM ERROR.{0,90}' "$d/$n.exp.opt.err")"
  [ $s2 -ne 0 ] && err="$err llc: $(grep -m1 -oE 'Assertion .{0,110}|LLVM ERROR.{0,110}' "$d/$n.exp.err")"
  printf '%s\tstock-llc=%s\texp-opt=%s\texp-llc=%s\tLV=%s\tSLP=%s\tpacked stock/exp=%s/%s\t%s\n' "$n" $s1 $o2 $s2 "$lv" "$slp" \
     "$(grep -cE '^\s+(pv\.|vf)' "$d/$n.stock.s" 2>/dev/null)" "$(grep -cE '^\s+(pv\.|vf)' "$d/$n.exp.s" 2>/dev/null)" "$err"
}
export -f one; export T EXP_OPT CF SF INC d
ls $DSP/*/*.c | xargs -P 12 -I{} bash -c 'one {}' > "$d/summary.tsv"
sort -o "$d/summary.tsv" "$d/summary.tsv"
# functions whose instruction count changed
for s in "$d"/*.stock.s; do n=$(basename "$s" .stock.s); [ -s "$d/$n.exp.s" ] || continue
  python3 "$here/asm_table.py" "$s" "$d/$n.exp.s" | awk -F'\t' -v n="$n" 'NR>1 && ($3!=$7 || $2!=$6) {print n"\t"$1"\tinsns "$3" -> "$7"\thwloops "$4" -> "$8"\tpacked: "$2" -> "$6}' >> "$d/functions.tsv"
done
echo "files: $(wc -l < "$d/summary.tsv"); functions changed: $(wc -l < "$d/functions.tsv")"
