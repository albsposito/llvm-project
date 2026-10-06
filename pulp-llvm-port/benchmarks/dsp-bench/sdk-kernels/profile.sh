#!/usr/bin/env bash
# Per-PC execution profile of one ELF on GVSoC (instruction trace), e.g.
#   ./profile.sh build/clang/O2/fft_f16/prog.elf Radix2FFT_DIF_Seq_f16 --top 60
# pc_profile.py here is gap9-sweep/runtime/pc_profile.py with the objdump of the benchmarked
# snapshot and GAP9 f16 decoding switched on.
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"
exec python3 pc_profile.py "$@"
