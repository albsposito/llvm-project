#!/bin/bash
# one.sh seed -> prints one status line (see README.md)
#
# Environment (all optional):
#   NEW      bin dir of the clang under test         (default build/20-F005/bin)
#   BASE     bin dir of the comparison clang         (default build/int-20/bin)
#   REF      host     : host gcc -O0 is the reference, cross-checked with GAP9 GCC
#                       -O2 -mnohwloop on GVSoC (default; backlog B101)
#            gap9gcc  : OLD behaviour, GAP9 GCC -O2 with hardware loops on GVSoC is the
#                       reference (it has a hardware-loop bug, B101; for comparison only)
#   XCHECK   1 = run the GAP9 GCC -mnohwloop cross-check with REF=host (default 1)
#   NSETS    input sets (n,m,k loop bounds) per seed, 1..3 (default 3; 1 with REF=gap9gcc)
#   OLEVELS  clang optimisation levels (default "O2 O3 Os")
#   WD       work root (default w, relative to the current directory); files in $WD/<seed>
#   CLANG_EXTRA  extra flags appended to the clang kernel compiles
seed=$1; [ -n "$seed" ] || { echo "usage: one.sh seed" >&2; exit 2; }
H=$(cd "$(dirname "$0")" && pwd)
P=/home/ubuntu/llvm-project/pulp-llvm-port; SIM=$P/benchmarks/gap9-sweep/sim
NEW=${NEW:-$P/build/20-F005/bin}; BASE=${BASE:-$P/build/int-20/bin}
REF=${REF:-host}; XCHECK=${XCHECK:-1}; OLEVELS=${OLEVELS:-"O2 O3 Os"}
case $REF in host) NSETS=${NSETS:-3};; gap9gcc) NSETS=${NSETS:-1};; *) echo "REF must be host or gap9gcc" >&2; exit 2;; esac
[ "$NSETS" -ge 1 ] && [ "$NSETS" -le 3 ] || { echo "NSETS must be 1..3" >&2; exit 2; }
d=${WD:-w}/$seed; mkdir -p $d
GCC=/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc
GCCROOT=/home/ubuntu/gap_riscv_toolchain_ubuntu
LIBGCC=$GCCROOT/lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32/libgcc.a
LF="--target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax -mllvm -pulp-loop-range-immediate=0"
GF="-ffreestanding -fno-builtin -I$SIM -nostdlib -static -T $SIM/link.ld $SIM/crt0.S $H/drv.c $d/kern.c -lgcc"
python3 $H/gen.py $seed > $d/kern.c
sim() { timeout 60 $SIM/run_sim.sh "$1" 2>&1 | grep -m1 '^RES'; }

# Input sets. Set 0 is the historical one.sh set (all bounds >= 1); sets 1 and 2 are the
# triage's random sets (scan/hostoracle.sh) and include zero bounds.
nmk() { local j=$1 x=$((seed*7919 + $1*104729))
  if [ $j -eq 0 ]; then echo "$((seed % 7 + 1)) $(((seed/7) % 9 + 1)) $(((seed/63)%5+1))"
  else echo "$((x%8)) $(((x/8)%10)) $(((x/80)%6))"; fi; }

# References, one per input set.
declare -a REFV NMKV
flags=""
for ((j=0; j<NSETS; j++)); do
  read N M K < <(nmk $j); NMKV[$j]="$N,$M,$K"; DEF="-DN_=$N -DM_=$M -DK_=$K"
  if [ $REF = gap9gcc ]; then
    $GCC -march=rv32imcxgap9 -O2 $DEF $GF -o $d/gcc.s$j.elf 2>$d/gcc.err || { echo "$seed GCCFAIL"; exit; }
    REFV[$j]=$(sim $d/gcc.s$j.elf)
  else
    gcc -O0 $DEF $H/hdrv.c $d/kern.c -o $d/host.s$j 2>$d/host.err || { echo "$seed REFFAIL"; exit; }
    REFV[$j]=$($d/host.s$j)
    if [ "$XCHECK" = 1 ]; then
      if $GCC -march=rv32imcxgap9 -O2 -mnohwloop $DEF $GF -o $d/gccnohw.s$j.elf 2>$d/gcc.err; then
        x=$(sim $d/gccnohw.s$j.elf)
        [ "$x" == "${REFV[$j]}" ] || flags="$flags REFDISAGREE[s$j:nmk=${NMKV[$j]}:host=${REFV[$j]#RES }:gap9nohwloop=${x#RES }]"
      else flags="$flags XCHECKFAIL[s$j]"; fi
    fi
  fi
done
case $REF in host) rn="host-gcc-O0"; [ "$XCHECK" = 1 ] && rn="$rn+gap9gcc-O2-nohwloop";; *) rn="gap9gcc-O2";; esac

$NEW/clang $LF -c $SIM/crt0.S -o $d/crt0.o
for ((j=0; j<NSETS; j++)); do
  IFS=, read N M K <<< "${NMKV[$j]}"
  $NEW/clang $LF -O0 -ffreestanding -fno-builtin -I$SIM -DN_=$N -DM_=$M -DK_=$K -c $H/drv.c -o $d/drv.s$j.o
done
line="$seed ref=[${REFV[0]}] refkind=$rn sets=$NSETS"
for o in $OLEVELS; do
  $BASE/clang $LF -$o $CLANG_EXTRA -S $d/kern.c -o $d/b.$o.s 2>/dev/null; bs=$?
  $NEW/clang $LF -$o $CLANG_EXTRA -S $d/kern.c -o $d/n.$o.s 2>$d/n.$o.err; ns=$?
  if [ $ns -ne 0 ]; then line="$line $o:NEWFAIL(base=$bs)"; continue; fi
  nl=$(grep -c 'lp\.' $d/n.$o.s)
  if [ $bs -ne 0 ]; then tag=BASECRASH; elif cmp -s <(grep -v ident $d/b.$o.s) <(grep -v ident $d/n.$o.s); then tag=same; else tag=CHANGED; fi
  $NEW/clang $LF -$o $CLANG_EXTRA -c $d/kern.c -o $d/n.$o.o 2>>$d/n.$o.err || { line="$line $o:OBJFAIL"; continue; }
  bad=""
  for ((j=0; j<NSETS; j++)); do
    $NEW/ld.lld -nostdlib -static -T $SIM/link.ld $d/crt0.o $d/drv.s$j.o $d/n.$o.o $LIBGCC -o $d/n.$o.s$j.elf
    res=$(sim $d/n.$o.s$j.elf)
    [ "$res" == "${REFV[$j]}" ] || bad="$bad,s$j:nmk=${NMKV[$j]}:got=${res:-none}:ref=${REFV[$j]}"
  done
  if [ -z "$bad" ]; then ok=OK; else ok="MISMATCH[${bad#,}]"; fi
  line="$line $o:$tag:lp$nl:$ok"
done
echo "$line$flags"
