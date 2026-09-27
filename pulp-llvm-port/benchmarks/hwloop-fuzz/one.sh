#!/bin/bash
# one.sh seed -> prints status line
seed=$1; d=w/$seed; mkdir -p $d
P=/home/ubuntu/llvm-project/pulp-llvm-port; SIM=$P/benchmarks/gap9-sweep/sim
NEW=$P/build/20-F005/bin; BASE=$P/build/int-20/bin
GCC=/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc
GCCROOT=/home/ubuntu/gap_riscv_toolchain_ubuntu
LF="--target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax -mllvm -pulp-loop-range-immediate=0"
python3 gen.py $seed > $d/kern.c
N=$((seed % 7 + 1)); M=$(((seed/7) % 9 + 1)); K=$(((seed/63)%5+1))
DEF="-DN_=$N -DM_=$M -DK_=$K"
$GCC -march=rv32imcxgap9 -O2 -ffreestanding -fno-builtin -I$SIM $DEF -nostdlib -static -T $SIM/link.ld $SIM/crt0.S drv.c $d/kern.c -lgcc -o $d/gcc.elf 2>$d/gcc.err || { echo "$seed GCCFAIL"; exit; }
ref=$($SIM/run_sim.sh $d/gcc.elf 2>&1 | grep -m1 '^RES')
$NEW/clang $LF -O0 -ffreestanding -fno-builtin -I$SIM $DEF -c drv.c -o $d/drv.o
$NEW/clang $LF -c $SIM/crt0.S -o $d/crt0.o
line="$seed ref=[$ref]"
for o in O2 O3 Os; do
  $BASE/clang $LF -$o -S $d/kern.c -o $d/b.$o.s 2>/dev/null; bs=$?
  $NEW/clang $LF -$o -S $d/kern.c -o $d/n.$o.s 2>$d/n.$o.err; ns=$?
  if [ $ns -ne 0 ]; then line="$line $o:NEWFAIL(base=$bs)"; continue; fi
  nl=$(grep -c 'lp\.' $d/n.$o.s)
  if [ $bs -ne 0 ]; then tag=BASECRASH; elif cmp -s <(grep -v ident $d/b.$o.s) <(grep -v ident $d/n.$o.s); then tag=same; else tag=CHANGED; fi
  $NEW/clang $LF -$o -c $d/kern.c -o $d/n.$o.o 2>>$d/n.$o.err || { line="$line $o:OBJFAIL"; continue; }
  $NEW/ld.lld -nostdlib -static -T $SIM/link.ld $d/crt0.o $d/drv.o $d/n.$o.o $GCCROOT/lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32/libgcc.a -o $d/n.$o.elf
  res=$(timeout 60 $SIM/run_sim.sh $d/n.$o.elf 2>&1 | grep -m1 '^RES')
  if [ "$res" == "$ref" ]; then ok=OK; else ok="MISMATCH[$res]"; fi
  line="$line $o:$tag:lp$nl:$ok"
done
echo "$line"
