#!/bin/bash
# build.sh <label> <cc> <opt> <kernel> [extra kernel flags...]  -> builds/<label>/<opt>/<kernel>/prog.elf, runs sim
set -e
H=/home/ubuntu/llvm-project/pulp-llvm-port; G=$H/benchmarks/gap9-sweep; R=$G/runtime; SIM=$G/sim
label=$1; cc=$2; opt=$3; k=$4; shift 4; extra=("$@")
out=$(dirname $0)/builds/$label/$opt/$k; rm -rf $out; mkdir -p $out; out=$(cd $out; pwd)
INC="-I$G/src/shim -I$G/build/gen -I/home/ubuntu/gap_sdk_release/tools/autotiler_v3/BasicKernels/DSP_Libraries -I/home/ubuntu/gap_sdk_release/tools/autotiler_v3/BasicKernels/DSP_Libraries/FastMathFunctions -I/home/ubuntu/gap_sdk_release/tools/autotiler_v3/Emulation -D__gap9__ -D__GAP9__ -D__pulp__"
src=$G/src/$k.c; [ -f $G/build/gen/$k.c ] && src=$G/build/gen/$k.c; [ -n "$SRC" ] && src=$SRC
if [[ $cc == *gcc ]]; then BASE="-march=rv32imcxgap9 -mPE=8 -mFC=1"; else BASE="--target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax -isystem /home/ubuntu/gap_riscv_toolchain_ubuntu/riscv32-unknown-elf/include"; fi
$cc $BASE $INC -$opt "${extra[@]}" -c $src -o $out/kernel.o
$cc $BASE -$opt -c $SIM/crt0.S -o $out/crt0.o
$cc $BASE -$opt -ffreestanding -fno-builtin -I$SIM -I$R -c $R/drivers/$k.c -o $out/driver.o
$cc $BASE -$opt -ffreestanding -fno-builtin -I$SIM -I$R -c $R/rt_libc.c -o $out/rt_libc.o
O="$out/crt0.o $out/driver.o $out/rt_libc.o $out/kernel.o"
if [[ $cc == *gcc ]]; then $cc $BASE -nostdlib -static -T $SIM/link.ld $O -lgcc -o $out/prog.elf
else $(dirname $cc)/ld.lld -nostdlib -static -T $SIM/link.ld $O /home/ubuntu/gap_riscv_toolchain_ubuntu/lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32/libgcc.a -o $out/prog.elf; fi
$H/build/int-20/bin/llvm-objdump -d --mattr=+m,+xpulpv,+zfinx $out/kernel.o > $out/kernel.dis
$SIM/run_sim.sh $out/prog.elf > $out/sim.log 2>&1 || true
echo "$label $opt $k: $(grep -o 'cycles=[0-9]* instrs=[0-9]* checksum=0x[0-9a-f]*' $out/sim.log)"
