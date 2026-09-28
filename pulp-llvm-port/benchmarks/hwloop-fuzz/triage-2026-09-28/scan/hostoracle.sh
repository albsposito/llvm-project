#!/bin/bash
# hostoracle.sh seed : int-20 clang on GVSoC vs host gcc -O0 oracle, 3 input sets (incl. zero bounds), O2/O3/Os
s=$1; H=/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/hwloop-fuzz; T=$H/triage-2026-09-28
P=/home/ubuntu/llvm-project/pulp-llvm-port; SIM=$P/benchmarks/gap9-sweep/sim; B=$P/build/int-20/bin
GR=/home/ubuntu/gap_riscv_toolchain_ubuntu/lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32/libgcc.a
LF="--target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax"
t=$(mktemp -d); python3 $H/gen.py $s > $t/k.c
$B/clang $LF -c $SIM/crt0.S -o $t/crt0.o
for o in O2 O3 Os; do $B/clang $LF -$o -c $t/k.c -o $t/k.$o.o 2>/dev/null || echo "$s $o COMPILEFAIL"; done
for j in 0 1 2; do
  x=$((s*7919 + j*104729)); N=$((x%8)); M=$(((x/8)%10)); K=$(((x/80)%6))
  [ $j -eq 0 ] && { N=$((s % 7 + 1)); M=$(((s/7) % 9 + 1)); K=$(((s/63)%5+1)); }
  DEF="-DN_=$N -DM_=$M -DK_=$K"
  gcc -O0 $DEF $T/host/hdrv.c $t/k.c -o $t/h 2>/dev/null; ref=$($t/h)
  $B/clang $LF -O0 -ffreestanding -fno-builtin -I$SIM $DEF -c $H/drv.c -o $t/d.o
  for o in O2 O3 Os; do
    [ -f $t/k.$o.o ] || continue
    $B/ld.lld -nostdlib -static -T $SIM/link.ld $t/crt0.o $t/d.o $t/k.$o.o $GR -o $t/e.elf
    res=$(timeout 60 $SIM/run_sim.sh $t/e.elf 2>&1 | grep -m1 '^RES')
    [ "$res" == "$ref" ] || echo "$s $o NMK=$N,$M,$K BAD ref=[$ref] got=[$res]"
  done
done; rm -rf $t
