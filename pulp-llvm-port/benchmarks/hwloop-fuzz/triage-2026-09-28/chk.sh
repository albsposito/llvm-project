#!/bin/bash
# chk.sh seed [kern.c] -> GCC reference vs int-20 clang at O0..Oz, on GVSoC
# env: CLANG_EXTRA (extra clang flags), MARCH (default rv32imc_zfinx_xpulpv2), OLEVELS
seed=$1; kern=$2
H=/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/hwloop-fuzz
T=$H/triage-2026-09-28
P=/home/ubuntu/llvm-project/pulp-llvm-port; SIM=$P/benchmarks/gap9-sweep/sim
BIN=${BIN:-$P/build/int-20/bin}
GCC=/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc
GCCROOT=/home/ubuntu/gap_riscv_toolchain_ubuntu
MARCH=${MARCH:-rv32imc_zfinx_xpulpv2}
LF="--target=riscv32-unknown-elf -march=$MARCH -mabi=ilp32 -mno-relax -mllvm -pulp-loop-range-immediate=0 $CLANG_EXTRA"
d=${WD:-$T/w/$seed}; mkdir -p $d
if [ -z "$kern" ]; then python3 $H/gen.py $seed > $d/kern.c; kern=$d/kern.c; fi
N=$((seed % 7 + 1)); M=$(((seed/7) % 9 + 1)); K=$(((seed/63)%5+1))
DEF="-DN_=$N -DM_=$M -DK_=$K"
if [ ! -f $d/ref.txt ] || [ -n "$NOCACHE" ]; then
$GCC -march=rv32imcxgap9 -O2 -ffreestanding -fno-builtin -I$SIM $DEF -nostdlib -static -T $SIM/link.ld $SIM/crt0.S $H/drv.c $kern -lgcc -o $d/gcc.elf 2>$d/gcc.err || { echo "$seed GCCFAIL"; exit; }
timeout 60 $SIM/run_sim.sh $d/gcc.elf 2>&1 | grep -m1 '^RES' > $d/ref.txt
fi
ref=$(cat $d/ref.txt)
$BIN/clang --target=riscv32-unknown-elf -march=rv32imc_zfinx -mabi=ilp32 -O0 -ffreestanding -fno-builtin -I$SIM $DEF -c $H/drv.c -o $d/drv.o
$BIN/clang --target=riscv32-unknown-elf -march=rv32imc_zfinx -mabi=ilp32 -c $SIM/crt0.S -o $d/crt0.o
line="$seed ref=[$ref]"
for o in ${OLEVELS:-O0 O1 O2 O3 Os Oz}; do
  $BIN/clang $LF -$o -c $kern -o $d/c.$o.o 2>$d/c.$o.err || { line="$line $o:FAIL"; continue; }
  $BIN/clang $LF -$o -S $kern -o $d/c.$o.s 2>/dev/null
  nl=$(grep -c 'lp\.setup' $d/c.$o.s)
  $BIN/ld.lld -nostdlib -static -T $SIM/link.ld $d/crt0.o $d/drv.o $d/c.$o.o $GCCROOT/lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32/libgcc.a -o $d/c.$o.elf
  res=$(timeout 60 $SIM/run_sim.sh $d/c.$o.elf 2>&1 | grep -m1 '^RES')
  if [ "$res" == "$ref" ]; then ok=OK; else ok="BAD[$res]"; fi
  line="$line $o:lp$nl:$ok"
done
echo "$line"
