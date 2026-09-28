#!/bin/bash
# host.sh seed [kern.c] : host gcc/clang at several -O and with UBSan/ASan
seed=$1; T=/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/hwloop-fuzz/triage-2026-09-28
kern=${2:-$T/w/$seed/kern.c}
N=$((seed % 7 + 1)); M=$(((seed/7) % 9 + 1)); K=$(((seed/63)%5+1))
DEF="-DN_=$N -DM_=$M -DK_=$K"; o=$(mktemp -d)
line="$seed"
for cc in gcc clang; do for O in O0 O2 O3; do
  $cc -$O $DEF $T/host/hdrv.c $kern -o $o/a 2>/dev/null && line="$line $cc-$O:[$($o/a)]"
done; done
gcc -O1 -g -fsanitize=undefined,address -fno-sanitize-recover=all $DEF $T/host/hdrv.c $kern -o $o/u 2>/dev/null && line="$line gcc-ubsan+asan:[$($o/u 2>&1 | head -3 | tr '\n' ' ')]"
echo "$line"; rm -rf $o
