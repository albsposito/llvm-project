#!/bin/bash
# scan1.sh seed : compile with int-20 at O2/O3/Os, report loops entered by >1 lp.setup with different end labels
s=$1; H=/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/hwloop-fuzz; B=/home/ubuntu/llvm-project/pulp-llvm-port/build/int-20/bin
LF="--target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax"
t=$(mktemp -d); python3 $H/gen.py $s > $t/k.c
for o in O2 O3 Os; do
  $B/clang $LF -$o -S $t/k.c -o $t/k.s 2>/dev/null || { echo "$s $o FAIL"; continue; }
  python3 $H/triage-2026-09-28/scan/multisetup.py $t/k.s | sed "s/^/$s $o /"
done; rm -rf $t
