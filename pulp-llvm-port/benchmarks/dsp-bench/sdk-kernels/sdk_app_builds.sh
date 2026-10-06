#!/usr/bin/env bash
# Stretch: build and link (not run) the six SDK DSP benchmark apps through the SDK's own CMake,
# with GAP9 GCC and with our clang through the benchmarks/sdk-clang wrapper.
#   variants: gcc | clang-compat-nowerror-gnuas-gnuld (setup A) | clang-compat-nowerror-sdkp (setup B)
#             | clang-gnuas-gnuld (wrapper only, SDK -Werror kept)
# Everything is written under $W (default: a temp dir); the SDK itself is not modified.
# Result: $W/stretch.tsv (app, variant, build rc). The copy next to this script is sdk-app-builds.tsv.
set -uo pipefail
HERE=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
PORT=$(readlink -f "$HERE/../../..")
SDKCLANG=$PORT/benchmarks/sdk-clang
BENCH=$PORT/toolchains/port-20-bench
W=${W:-$(mktemp -d /tmp/dsp-bench-sdkwork.XXXXXX)}
mkdir -p "$W/snap/bin" "$W/snap/lib"
for t in "$BENCH"/bin/*; do ln -sf "$t" "$W/snap/bin/$(basename "$t")"; done
ln -sf "$BENCH/bin/llvm-ar" "$W/snap/bin/llvm-ranlib"          # the snapshot has no llvm-ranlib
ln -sfn "$BENCH/lib/clang" "$W/snap/lib/clang"
if [ ! -x "$W/venv/bin/python" ]; then
  python3 -m venv "$W/venv" && "$W/venv/bin/pip" install -q kconfiglib xxhash fdt numpy matplotlib scipy
fi
# configure needs a gvrun to exist (CONFIG_PLATFORM_GVSOC2); nothing is run, so the SDK's own install is enough
ln -sfn /home/ubuntu/gap_sdk_release/install/gvsoc2 "$W/gvsoc2-install"
export SDK_CLANG_WORK=$W SKIP_GVSOC=1
"$SDKCLANG/setup.sh" && "$SDKCLANG/make_patched_mirror.sh" || exit 1
export GAP_CLANG_ROOT=$W/snap GAP_CLANG_MARCH=rv32imc_xgap9 JOBS=6
: > "$W/stretch.tsv"
cd "$SDKCLANG"
for app in Fir DftSimple FFTL1 RFFTL1 IRFFTL1 MatMul; do
  for var in gcc clang-compat-nowerror-gnuas-gnuld clang-compat-nowerror-sdkp clang-gnuas-gnuld; do
    ( ./build_app.sh examples/gap9/dsp/benchmarks/$app $var > "$W/$app.$var.out" 2>&1
      echo -e "$app\t$var\t$?" >> "$W/stretch.tsv" ) &
  done
  wait
done
sort "$W/stretch.tsv"
echo "work dir: $W"
