#!/usr/bin/env bash
# Run the whole board pack, then collect everything into one text file to send back.
#   scripts/run_all.sh            build from source with your SDK where possible (recommended)
#   scripts/run_all.sh prebuilt   run only the prebuilt ELFs (built on SDK 5.21.14, GAP9 EVK v1.3 config)
#   scripts/run_all.sh both       both of the above
# Needs: the GAP9 SDK environment sourced (configs/<board>.sh), the board connected, the same
# setup with which `cmake --build build --target run` works for the SDK's helloworld.
# Results: results/*.log and results/board-results-<date>.txt (send the latter back).
# Env: PACK_TIMEOUT (seconds per test, default 300), GAP_CLANG_ROOT (our clang, optional:
# without it the all-clang test-7 apps run from prebuilt ELFs), PACK_PLATFORM=gvsoc (simulator).
set -o pipefail
MODE=${1:-source}
source "$(dirname "$0")/lib.sh"; pack_need_sdk
PB=$PACK/prebuilt/board
if [ -z "${GAP_CLANG_ROOT:-}" ] && [ -x "$PACK/toolchain/clang-snap/bin/clang" ]; then
  export GAP_CLANG_ROOT=$PACK/toolchain/clang-snap
fi
have_clang=0
[ -n "${GAP_CLANG_ROOT:-}" ] && "$GAP_CLANG_ROOT/bin/clang" --version >/dev/null 2>&1 && have_clang=1
echo "[board-pack] mode=$MODE platform=$PLATFORM clang=$([ $have_clang = 1 ] && echo "$GAP_CLANG_ROOT" || echo 'none (prebuilt clang ELFs are used)')"

if [ "$MODE" = source ] || [ "$MODE" = both ]; then
  # Tests 1-5 and 8: GAP9 GCC only. Test 2 last: if misaligned hardware loops hang the core, the other
  # results are already saved.
  pack_test t1_b101_gcc_hwloop     "$PACK/t1_b101_gcc_hwloop"
  pack_test t3_fp16_vcmp_lanes_b99 "$PACK/t3_fp16_vcmp_lanes_b99"
  pack_test t4_shuffle_sci_h_b114  "$PACK/t4_shuffle_sci_h_b114"
  pack_test t5_shuffle2_order_b113 "$PACK/t5_shuffle2_order_b113"
  pack_test t8_vfmre_sign_b151    "$PACK/t8_vfmre_sign_b151"
  pack_test t2_hwloop_align_b68    "$PACK/t2_hwloop_align_b68"
  # Test 6: GCC libraries built here; clang libraries prebuilt (or rebuilt with GAP_CLANG_ROOT).
  pack_test t6_kernels.gcc-O2 "$PACK/t6_kernels_clang_vs_gcc" -DPACK_KERNELS=gcc-O2
  pack_test t6_kernels.gcc-O3 "$PACK/t6_kernels_clang_vs_gcc" -DPACK_KERNELS=gcc-O3
  for o in O2 O3; do
    if [ $have_clang = 1 ]; then
      pack_test t6_kernels.clang-$o "$PACK/t6_kernels_clang_vs_gcc" -DPACK_KERNELS=clang-$o -DPACK_CLANG="$GAP_CLANG_ROOT/bin/clang"
    else
      pack_test t6_kernels.clang-$o "$PACK/t6_kernels_clang_vs_gcc" -DPACK_KERNELS=clang-$o
    fi
  done
  # Test 7: SDK examples + core-count app, all-GCC from source; all-clang from source if we have
  # clang, else from the prebuilt ELFs.
  for a in "$GAP_SDK_HOME/examples/gap9/basic/helloworld" "$GAP_SDK_HOME/examples/gap9/basic/perf" "$PACK/t7_sdk_apps_clang/t7_corecount"; do
    n=$(basename "$a"); n=t7_${n#t7_}
    pack_t7 "$n.gcc" "$a" gcc
    for v in clang clang-ccfix; do
      if [ $have_clang = 1 ]; then pack_t7 "$n.$v" "$a" "$v"; else pack_prebuilt "$n.$v" "$PB/$n.$v.elf"; fi
    done
  done
fi
if [ "$MODE" = prebuilt ] || [ "$MODE" = both ]; then
  for e in "$PB"/t1_*.elf "$PB"/t3_*.elf "$PB"/t4_*.elf "$PB"/t5_*.elf "$PB"/t8_*.elf "$PB"/t6_*.elf "$PB"/t7_*.elf "$PB"/t2_*.elf; do
    pack_prebuilt "prebuilt.$(basename "$e" .elf)" "$e"
  done
fi
"$PACK/scripts/collect_results.sh"
