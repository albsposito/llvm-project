#!/usr/bin/env bash
# Reproduce a GAP9 SDK DSP kernel compile with a given clang.
#   steps/20/fixes/repro.sh <clang> <sdk-relative-or-absolute .c> [extra flags...]
# e.g. steps/20/fixes/repro.sh toolchains/ref-18/bin/clang tools/autotiler_v3/BasicKernels/DSP_Libraries/FilteringFunctions/FirBasicKernelsFix.c -O2
here="$(cd "$(dirname "$0")" && pwd)"; cc=$1; src=$2; shift 2
SDK=/home/ubuntu/gap_sdk_release; D=$SDK/tools/autotiler_v3/BasicKernels/DSP_Libraries
case "$src" in /*) ;; *) src=$SDK/$src ;; esac
exec "$cc" --target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax -c \
  -I"$here/shim" -I$SDK/libs/include -I$D -isystem /home/ubuntu/gap_riscv_toolchain_ubuntu/riscv32-unknown-elf/include \
  "$src" -o /dev/null "${@:--O2}"
