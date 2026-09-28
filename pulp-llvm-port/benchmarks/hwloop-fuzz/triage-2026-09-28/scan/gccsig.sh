#!/bin/bash
# gccsig.sh seed : does GAP9 GCC -O2 emit the wrong-count "lp.setupi xN,1" signature?
s=$1; H=/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/hwloop-fuzz
G=/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc
t=$(mktemp -d); python3 $H/gen.py $s > $t/k.c
$G -march=rv32imcxgap9 -O2 -S $t/k.c -o $t/k.s 2>/dev/null && grep -q 'lp.setupi[^,]*,1,' $t/k.s && echo "$s GCC-SIG"
rm -rf $t
