#!/usr/bin/env bash
# B156: run loops2.c on GVSoC (ri5ky_testbench) built five ways and compare
# results and cycles. Needs EXP_OPT (see run_exp.sh) for the two "exp" variants.
#   gccO2, gccO3      GAP9 GCC
#   clangO3           stock port-20-bench clang (no vectorization)
#   exp               experimental opt (exp-tti.patch), stock llc
#   exp-ualign        same + target feature unaligned-scalar-mem
#   exp-txt, exp-ualign-txt   same two, llc fed textual IR instead of bitcode
# Output: out/sim/<variant>.txt and out/sim/table.tsv
set -u
here="$(cd "$(dirname "$0")" && pwd)"
P=/home/ubuntu/llvm-project/pulp-llvm-port; SIM=$P/benchmarks/gap9-sweep/sim
T=$P/toolchains/port-20-bench/bin
GCCROOT=/home/ubuntu/gap_riscv_toolchain_ubuntu; GCC=$GCCROOT/bin/riscv32-unknown-elf-gcc
LIBGCC=$GCCROOT/lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32/libgcc.a
CF="--target=riscv32-unknown-elf -march=rv32imc_xgap9 -mPE=8 -mabi=ilp32 -mno-relax"
d="$here/out/sim"; mkdir -p "$d"
sim() { timeout 300 "$SIM/run_sim.sh" "$1" 2>&1 | grep '^R ' ; }
# NO_SUM16N everywhere so that all five programs are the same source
DEF="-DNO_SUM16N"
for O in O2 O3; do
  $GCC -march=rv32imcxgap9 -mPE=8 -mFC=1 -$O $DEF -ffreestanding -fno-builtin -I$SIM -nostdlib -static \
     -T $SIM/link.ld $SIM/crt0.S "$here/simdrv.c" "$here/loops2.c" -lgcc -o "$d/gcc$O.elf" || exit 1
  sim "$d/gcc$O.elf" > "$d/gcc$O.txt"
done
"$T/clang" $CF -c $SIM/crt0.S -o "$d/crt0.o" || exit 1
"$T/clang" $CF -O1 $DEF -ffreestanding -fno-builtin -I$SIM -c "$here/simdrv.c" -o "$d/drv.o" || exit 1
link() { "$T/ld.lld" -nostdlib -static -T $SIM/link.ld "$d/crt0.o" "$d/drv.o" "$1" $LIBGCC -o "$2"; }
"$T/clang" $CF -O3 $DEF -c "$here/loops2.c" -o "$d/k.clangO3.o" && link "$d/k.clangO3.o" "$d/clangO3.elf" && sim "$d/clangO3.elf" > "$d/clangO3.txt"
if [ -n "${EXP_OPT:-}" ]; then
  for v in exp exp-ualign; do
    "$T/clang" $CF -O3 $DEF -S -emit-llvm -Xclang -disable-llvm-passes "$here/loops2.c" -o "$d/k.$v.O0.ll" || exit 1
    [ $v = exp-ualign ] && sed -i 's/"target-features"="/"target-features"="+unaligned-scalar-mem,/' "$d/k.$v.O0.ll"
    "$EXP_OPT" -passes='default<O3>' "$d/k.$v.O0.ll" -o "$d/k.$v.bc" || exit 1
    "$T/llc" -O3 -filetype=obj "$d/k.$v.bc" -o "$d/k.$v.o" || exit 1
    link "$d/k.$v.o" "$d/$v.elf" && sim "$d/$v.elf" > "$d/$v.txt"
    # Same module handed to llc as textual IR instead of bitcode. The IR is
    # identical, only the use-list order differs, and with it whether the
    # PULP hardware-loop pass converts the vector loop (report section 3).
    "$EXP_OPT" -passes='default<O3>' "$d/k.$v.O0.ll" -S -o "$d/k.$v.txt.ll" || exit 1
    "$T/llc" -O3 -filetype=obj "$d/k.$v.txt.ll" -o "$d/k.$v.txt.o" || exit 1
    link "$d/k.$v.txt.o" "$d/$v-txt.elf" && sim "$d/$v-txt.elf" > "$d/$v-txt.txt"
  done
fi
# Stress variants: force the vectorization factor on EVERY loop and use in-loop
# reductions (what TTI::preferInLoopReduction would select); unaligned on.
if [ -n "${EXP_OPT:-}" ]; then
  for spec in "exp-force2:-force-vector-width=2 -force-vector-interleave=1 -prefer-inloop-reductions" \
              "exp-force4:-force-vector-width=4 -force-vector-interleave=1 -prefer-inloop-reductions" \
              "exp-force2x2:-force-vector-width=2 -force-vector-interleave=2"; do
    v=${spec%%:*}; fl=${spec#*:}
    sed 's/"target-features"="/"target-features"="+unaligned-scalar-mem,/' "$d/k.exp.O0.ll" > "$d/k.$v.O0.ll"
    "$EXP_OPT" -passes='default<O3>' $fl "$d/k.$v.O0.ll" -o "$d/k.$v.bc" || { echo "$v: opt failed"; continue; }
    "$T/llc" -O3 -filetype=obj "$d/k.$v.bc" -o "$d/k.$v.o" 2> "$d/k.$v.llc.err" || { echo "$v: llc failed: $(grep -m1 -oE 'Assertion.{0,120}|LLVM ERROR.{0,120}' "$d/k.$v.llc.err")"; continue; }
    link "$d/k.$v.o" "$d/$v.elf" && sim "$d/$v.elf" > "$d/$v.txt"
  done
fi
python3 - "$d" <<'PY'
import sys, os
d = sys.argv[1]; vs = [v for v in ['gccO2', 'gccO3', 'clangO3', 'exp', 'exp-txt', 'exp-ualign', 'exp-ualign-txt', 'exp-force2', 'exp-force4', 'exp-force2x2'] if os.path.exists(f'{d}/{v}.txt') and os.path.getsize(f'{d}/{v}.txt')]
tab = {v: {l.split()[1]: l.split()[2:] for l in open(f'{d}/{v}.txt')} for v in vs}
names = list(tab['gccO2'].keys())
with open(f'{d}/table.tsv', 'w') as f:
    f.write('loop\tresults\t' + '\t'.join(f'{v} cyc al/misal' for v in vs) + '\n')
    for n in names:
        hs = {v: tab[v].get(n, ['?'])[0] for v in vs}
        ref = hs['gccO2']
        bad = [v for v in vs if hs[v] != ref]
        res = 'all equal' if not bad else 'DIFFER from gccO2: ' + ','.join(bad)
        f.write(n + '\t' + res + '\t' + '\t'.join('/'.join(tab[v].get(n, ['?', '?', '?'])[1:3]) for v in vs) + '\n')
print(open(f'{d}/table.tsv').read())
PY
