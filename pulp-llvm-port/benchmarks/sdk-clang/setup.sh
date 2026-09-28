#!/usr/bin/env bash
# One-time setup for the SDK-with-clang prototype (backlog B29).
#   SDK_CLANG_WORK  scratch dir (default /tmp/sdk-clang-work)
# Creates, all under $SDK_CLANG_WORK (the SDK itself is never written):
#   snap/        copy of build/int-20 clang, lld, llvm-{ar,nm,objdump,size,...}
#                and the clang resource headers (int-20 is rebuilt during the day)
#   sdk/         SDK mirror: examples/ copied, nn_menu/ copied, every other entry a
#                symlink (CMake configure writes sdkconfig etc. into app dirs)
#   venv/        kconfiglib, xxhash, fdt for the SDK's Kconfig/devicetree tools
#   gvsoc2-*/    GVSoC2 with the gap.gap9.evk platform, built out of tree from the
#                SDK's gvsoc2 sources (the SDK's own install/gvsoc2 only has
#                ri5ky_testbench)
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
W=${SDK_CLANG_WORK:-/tmp/sdk-clang-work}
SDK=${SDK:-/home/ubuntu/gap_sdk_release}
INT=${INT:-/home/ubuntu/llvm-project/pulp-llvm-port/build/int-20}
export PYTHONDONTWRITEBYTECODE=1
mkdir -p "$W"
if [ ! -x "$W/snap/bin/clang-20" ]; then
  mkdir -p "$W/snap/bin" "$W/snap/lib"
  cp "$INT/bin/clang-20" "$INT/bin/lld" "$W/snap/bin/"
  for t in llvm-objdump llvm-ar llvm-nm llvm-size llvm-readelf llvm-objcopy llvm-ranlib; do
    cp -L "$INT/bin/$t" "$W/snap/bin/"; done
  ln -sf clang-20 "$W/snap/bin/clang"; ln -sf lld "$W/snap/bin/ld.lld"
  cp -r "$INT/lib/clang" "$W/snap/lib/"
  "$W/snap/bin/clang" --version | head -1 > "$W/snap/VERSION"
fi
if [ ! -d "$W/sdk" ]; then
  mkdir -p "$W/sdk/tools"
  for e in $(ls -A "$SDK"); do case $e in examples|nn_menu|tools|.git) ;; *) ln -s "$SDK/$e" "$W/sdk/$e";; esac; done
  for e in $(ls -A "$SDK/tools"); do ln -s "$SDK/tools/$e" "$W/sdk/tools/$e"; done
  cp -a "$SDK/examples" "$W/sdk/examples"
  cp -a "$SDK/nn_menu" "$W/sdk/nn_menu"
fi
if [ ! -x "$W/venv/bin/python" ]; then
  python3 -m venv "$W/venv"; "$W/venv/bin/pip" install -q kconfiglib xxhash fdt
fi
if [ ! -x "$W/gvsoc2-install/bin/gvrun" ] && [ "${SKIP_GVSOC:-0}" != 1 ]; then
  W=$W "$HERE/build_gvsoc_gap9.sh"
fi
echo "setup done in $W"
