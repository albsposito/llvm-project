#!/bin/bash
# Builds numeq.c with GAP9 GCC (float16, float16alt) and clang (_Float16, __bf16) in several
# flag variants, runs each on GVSoC ri5ky_testbench and prints a side-by-side table.
set -u
HERE=$(cd $(dirname $0) && pwd)
P=/home/ubuntu/llvm-project/pulp-llvm-port
SIM=$P/benchmarks/gap9-sweep/sim
CLBIN=${CLBIN:-$P/build/int-20/bin}
GCC=/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc
LIBGCC=/home/ubuntu/gap_riscv_toolchain_ubuntu/lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32/libgcc.a
CRT=${CRT:-$P/wt/int-20/compiler-rt/lib/builtins}
O=${OUT:-$HERE/out}; mkdir -p $O
CF="--target=riscv32-unknown-elf -march=rv32imc_zfinx_zhinx_xpulpv2 -mabi=ilp32 -mno-relax -O2 -ffreestanding -fno-builtin -nostdlib -I$SIM -mllvm -pulp-loop-range-immediate=0"
$CLBIN/clang $CF -c $SIM/crt0.S -o $O/crt0.o
# compiler-rt soft bf16 truncation (libgcc 7 has no __truncsfbf2)
$CLBIN/clang $CF -I$CRT -c $CRT/truncsfbf2.c -o $O/truncsfbf2.o
rm -f $O/*.elf
build_gcc() { # name type alt [extra]
  $GCC -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -ffreestanding -fno-builtin -I$SIM -DT=$2 -DALT=$3 ${4:-} -nostdlib -static -T $SIM/link.ld $SIM/crt0.S $HERE/numeq.c -lgcc -o $O/$1.elf
}
build_clang() { # name type alt extra...
  n=$1; t=$2; a=$3; shift 3
  $CLBIN/clang $CF "$@" -DT=$t -DALT=$a -c $HERE/numeq.c -o $O/$n.o && \
  $CLBIN/ld.lld -nostdlib -static -T $SIM/link.ld $O/crt0.o $O/$n.o $O/truncsfbf2.o $LIBGCC -o $O/$n.elf
}
build_gcc   gcc-f16      float16    0
build_gcc   gcc-f16alt   float16alt 1
build_gcc   gcc-f16-nocontract    float16 0 -ffp-contract=off
build_gcc   gcc-f16alt-nocontract float16alt 1 -ffp-contract=off
build_clang cl-f16       _Float16 0
build_clang cl-f16-fast  _Float16 0 -ffp-contract=fast
build_clang cl-bf16      __bf16   1
build_clang cl-bf16-none __bf16   1 -Xclang -fbfloat16-excess-precision=none
build_clang cl-bf16-none-fast __bf16 1 -Xclang -fbfloat16-excess-precision=none -ffp-contract=fast
for e in gcc-f16 gcc-f16-nocontract cl-f16 cl-f16-fast gcc-f16alt gcc-f16alt-nocontract cl-bf16 cl-bf16-none cl-bf16-none-fast; do
  [ -f $O/$e.elf ] || { echo "BUILD-FAILED" > $O/$e.txt; continue; }
  timeout 120 $SIM/run_sim.sh $O/$e.elf 2>&1 | grep -v -E '^\[run_sim\]|^$' > $O/$e.txt
done
cols=(gcc-f16 gcc-f16-nocontract cl-f16 cl-f16-fast gcc-f16alt gcc-f16alt-nocontract cl-bf16 cl-bf16-none cl-bf16-none-fast)
cmd="paste <(echo kernel; awk '{print \$1}' $O/gcc-f16.txt)"
for c in "${cols[@]}"; do cmd="$cmd <(echo $c; awk '{print \$NF}' $O/$c.txt)"; done
eval "$cmd" | column -t | tee $O/table.txt
