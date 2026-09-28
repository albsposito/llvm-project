#!/bin/bash
# gccvar.sh seed "gcc flags"... : run GAP9 GCC builds with various flags on GVSoC
seed=$1; shift
H=/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/hwloop-fuzz; T=$H/triage-2026-09-28
SIM=/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/gap9-sweep/sim
GCC=/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc
kern=${KERN:-$T/w/$seed/kern.c}
N=$((seed % 7 + 1)); M=$(((seed/7) % 9 + 1)); K=$(((seed/63)%5+1)); DEF="-DN_=$N -DM_=$M -DK_=$K"
o=$(mktemp -d); line="$seed"
for f in "$@"; do
  $GCC $f -ffreestanding -fno-builtin -I$SIM $DEF -nostdlib -static -T $SIM/link.ld $SIM/crt0.S $H/drv.c $kern -lgcc -o $o/g.elf 2>/dev/null || { line="$line [$f]:FAIL"; continue; }
  line="$line [$f]:$(timeout 60 $SIM/run_sim.sh $o/g.elf 2>&1 | grep -m1 '^RES'|cut -c5-)"
done; echo "$line"; rm -rf $o
