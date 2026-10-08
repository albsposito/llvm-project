#!/usr/bin/env bash
# B156 investigation: reproduce every table of report.md.
#   ./reproduce.sh            stock-compiler parts only
#   EXP_OPT=<experimental opt> ./reproduce.sh     also the experiment (sections 3 and 6)
# The experimental opt = integration head 26e7268c3127 + exp-tti.patch, target `opt`:
#   git -C /home/ubuntu/llvm-project worktree add --detach <dir> 26e7268c3127
#   git -C <dir> apply <this dir>/exp-tti.patch
#   cmake -G Ninja -S <dir>/llvm -B <bld> -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON \
#         -DLLVM_TARGETS_TO_BUILD=RISCV -DLLVM_DEFAULT_TARGET_TRIPLE=riscv32-unknown-elf \
#         -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_USE_LINKER=lld -DLLVM_INCLUDE_TESTS=OFF
#   ninja -C <bld> opt            (about 12 minutes at -j14)
set -u
cd "$(dirname "$0")"
P=/home/ubuntu/llvm-project/pulp-llvm-port; T=$P/toolchains/port-20-bench/bin
G=/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc
CF="--target=riscv32-unknown-elf -march=rv32imc_xgap9 -mPE=8 -mabi=ilp32"; GF="-march=rv32imcxgap9 -mPE=8 -mFC=1"
mkdir -p out/gcc out/clang

echo "== 1. Do the vectorizers run? (stock clang)"
"$T/clang" $CF -O3 -S -emit-llvm -Xclang -disable-llvm-passes ../loops.c -o out/loops.O0.ll
"$T/opt" -passes='default<O3>' -debug-pass-manager out/loops.O0.ll -o /dev/null 2>&1 | grep -E "Running pass: (LoopVectorize|SLPVectorizer|VectorCombine)Pass" | sort | uniq -c
"$T/opt" -passes='default<O3>' -debug-only=loop-vectorize,SLP out/loops.O0.ll -o /dev/null 2>&1 | sort | uniq -c
echo "== 2. Cost model answers (stock opt): out/cost.default.txt"
"$T/opt" -passes='print<cost-model>' -disable-output cost.ll 2>&1 | sed 's/Cost Model: Found an estimated cost of //' > out/cost.default.txt; head -12 out/cost.default.txt
echo "== 3. Forcing flags and pragma (stock clang): packed instructions emitted"
for fl in "-mllvm -force-vector-width=2" "-mllvm -force-vector-width=4" "-mllvm -force-target-max-vector-interleave=2" \
          "-mllvm -riscv-v-fixed-length-vector-lmul-max=8" "-mllvm -vectorizer-min-trip-count=1" \
          "-mllvm -force-target-num-vector-regs=16 -mllvm -force-vector-width=2" "-fslp-vectorize"; do
  "$T/clang" $CF -O3 -S ../loops.c -o out/t.s $fl 2>/dev/null; echo "  $fl: $(grep -cE '^\s+pv\.' out/t.s)"
done
"$T/clang" $CF -O3 -S pragma.c -o out/pragma.s 2>&1 | grep -c "loop not vectorized" | sed 's/^/  pragma.c: "loop not vectorized" warnings: /'
echo "== 3b. Scalar misaligned access: GCC vs clang (unaligned_scalar.c)"
$G $GF -O2 -S unaligned_scalar.c -o - | grep -cE '^\s+l(w|bu)' | sed 's/^/  gcc loads: /'
"$T/clang" $CF -O2 -S unaligned_scalar.c -o - | grep -cE '^\s+l(w|bu)' | sed 's/^/  clang loads: /'
echo "== 4. Back-end coverage: out/backend.default.tsv, out/backend.unaligned.tsv"
bash run_backend.sh; cp out/backend.tsv out/backend.default.tsv
MATTR="+m,+c,+xgap,+xpulpv,+xpulpfvec,+xpulpf16alt,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,+unaligned-scalar-mem" bash run_backend.sh 2>/dev/null; cp out/backend.tsv out/backend.unaligned.tsv
echo "== 4b. Crash reproducers (stock llc/opt)"
M="+m,+c,+xgap,+xpulpv,+xpulpfvec,+xpulpf16alt,+zfinx,+zhinx,+zhinxmin"
for f in crashes/c[123]*.ll; do echo "  $f: $("$T/llc" -mtriple=riscv32-unknown-elf -mattr=$M $f -o /dev/null 2>&1 | grep -m1 -oE 'Assertion.{0,90}|LLVM ERROR.{0,60}')"; done
echo "  crashes/c4: $("$T/opt" -passes=loop-vectorize -pass-remarks-missed=loop-vectorize crashes/c4_lv_remark_ordered_fadd_generic.ll -S -o /dev/null 2>&1 | grep -m1 -oE 'Assertion.{0,90}')"
echo "== 5. GCC -O2/-O3 and stock clang -O3 per loop: out/gcc/*.s, out/clang/*.s"
for f in loops2 loops3 loops_f16; do
  for O in O2 O3; do $G $GF -$O -S $f.c -o out/gcc/$f.$O.s -fopt-info-vec-optimized 2> out/gcc/$f.$O.vec.txt; done
  "$T/clang" $CF -O3 -S $f.c -o out/clang/$f.O3.s
  python3 asm_table.py out/gcc/$f.O2.s out/gcc/$f.O3.s out/clang/$f.O3.s > out/table.$f.tsv
done
column -t -s$'\t' out/table.loops2.tsv | cut -c1-200
if [ -n "${EXP_OPT:-}" ]; then
  echo "== 6. Experiment: vectorizers on (exp-tti.patch)"
  bash run_exp.sh base; MATTR_EXTRA=,+unaligned-scalar-mem bash run_exp.sh ualign
  SRCS=loops3 MATTR_EXTRA=,+unaligned-scalar-mem bash run_exp.sh ualign
  ./lv_costs.sh out/exp/base/loops2.O0.ll > out/exp/base/lv_costs.loops2.tsv
  bash run_sim.sh | column -t -s$'\t'
  bash sdk_sweep.sh; column -t -s$'\t' out/sdk/functions.tsv
fi
