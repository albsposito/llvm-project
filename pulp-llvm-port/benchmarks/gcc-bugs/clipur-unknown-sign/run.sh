#!/bin/bash
# run.sh <tag> <compiler cmd...>
P=/home/ubuntu/llvm-project/pulp-llvm-port; SIM=$P/benchmarks/gap9-sweep/sim; D=$(dirname $(readlink -f $0)); T=$1; shift
B=$P/build/int-20/bin; GCC=/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc
LF="--target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax -ffreestanding -fno-builtin -nostdlib -I $SIM"
[ -f $D/ref.o ] || { $B/clang $LF -c $SIM/crt0.S -o $D/crt0.o; $B/clang $LF -O0 -c $D/m.c -o $D/m.o; $GCC -march=rv32imc -mabi=ilp32 -O0 -ffreestanding -c $D/ref.c -o $D/ref.o || exit 1; }
for o in O2 O3 Os; do
 "$@" -$o -c $D/k.c -o $D/k.$T.$o.o || { echo "$T $o COMPILEFAIL"; continue; }
 $B/ld.lld -nostdlib -static -T $SIM/link.ld $D/crt0.o $D/m.o $D/ref.o $D/k.$T.$o.o -o $D/$T.$o.elf || { echo LINKFAIL; continue; }
 $B/llvm-objdump -d --no-show-raw-insn $D/k.$T.$o.o > $D/k.$T.$o.dis
 echo "== $T $o: $(grep -c 'p.clipr' $D/k.$T.$o.dis) p.clipr, $(grep -c 'p.clipur' $D/k.$T.$o.dis) p.clipur"
 $SIM/run_sim.sh $D/$T.$o.elf 2>&1 | grep -E 'MISMATCH|checks=|exit code' | head -12
done
