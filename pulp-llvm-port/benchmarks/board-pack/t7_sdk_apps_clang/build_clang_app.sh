#!/usr/bin/env bash
# Build a GAP9 SDK CMake app entirely with our clang (or with GCC, for reference), using the
# SDK's own CMake flow and the sdk-clang drop-in (sdk-clang/: an initial-cache file that swaps
# the SDK's compiler for a GCC-compatible clang wrapper; no SDK file is modified).
#
#   t7_sdk_apps_clang/build_clang_app.sh <app dir> <board|gvsoc> <build dir> <gcc|clang|clang-ccfix>
#
#   gcc          GAP9 GCC, the SDK default (reference)
#   clang        our clang compiles every C file of the app AND of the SDK runtime; GAP9 GCC
#                assembles the runtime's .S files and GNU ld links ("setup A" of
#                benchmarks/sdk-clang/report.txt). Expect B107: cluster forks run on 0 cores.
#   clang-ccfix  as clang, plus sdk-clang/gap9_clang_compat.h force-included, which folds
#                __builtin_pulp_CoreCount() to 8 like GCC does (workaround until task 20/F018)
#
# Apps under $GAP_SDK_HOME (e.g. $GAP_SDK_HOME/examples/gap9/basic/helloworld) are copied into
# <build dir>/src first, so the SDK tree is not written. Pack apps are built in place.
# Environment: GAP_SDK_HOME (source the SDK config), GAP9 GCC on PATH, and
#   GAP_CLANG_ROOT  our clang install (bin/clang, bin/llvm-ar, lib/clang/20/include); default
#                   <pack>/toolchain/clang-snap (unpack toolchain/*.tar.xz there)
#   GAP_CLANG_MARCH default rv32imc_xgap9
# The ELF is <build dir>/<app name>; `cmake --build <build dir> --target run` runs it.
set -eo pipefail
[ $# -ge 4 ] || { sed -n 2,20p "$0"; exit 2; }
HERE=$(cd "$(dirname "$0")" && pwd); PACK=$(cd "$HERE/.." && pwd)
APP=$(cd "$1" && pwd); P=$2; V=$4
mkdir -p "$3"; BLD=$(cd "$3" && pwd)
: "${GAP_SDK_HOME:?source your GAP9 SDK config first}"
GCC_BIN=$(command -v riscv32-unknown-elf-gcc) || { echo "riscv32-unknown-elf-gcc not on PATH" >&2; exit 2; }
export GAP_GCC_TC=$(cd "$(dirname "$GCC_BIN")/.." && pwd)
export GAP_CLANG_ROOT=${GAP_CLANG_ROOT:-$PACK/toolchain/clang-snap}
export GAP_CLANG_MARCH=${GAP_CLANG_MARCH:-rv32imc_xgap9}
export GAP_CLANG_LINKER=gnu GAP_CLANG_AS=gnu
export GAP_CLANG_LOG=$BLD/clang-cmds.log
unset GAP_CLANG_COMPAT
CM=()
case $V in
  gcc) ;;
  clang) CM=(-C "$HERE/sdk-clang/clang-gap9.cmake") ;;
  clang-ccfix) CM=(-C "$HERE/sdk-clang/clang-gap9.cmake"); export GAP_CLANG_COMPAT=1 ;;
  *) echo "variant must be gcc, clang or clang-ccfix" >&2; exit 2 ;;
esac
if [ "$V" != gcc ] && [ ! -x "$GAP_CLANG_ROOT/bin/clang" ]; then
  echo "no clang in GAP_CLANG_ROOT=$GAP_CLANG_ROOT (unpack toolchain/*.tar.xz, see README)" >&2; exit 2
fi
case $P in
  board) PF=(-DCONFIG_PLATFORM_BOARD=y) ;;
  gvsoc) PF=(-DCONFIG_PLATFORM_GVSOC2=y) ;;
  *) echo "platform must be board or gvsoc" >&2; exit 2 ;;
esac
SRC=$APP
case $APP/ in
  "$(cd "$GAP_SDK_HOME" && pwd -P)"/*|"$GAP_SDK_HOME"/*)
    SRC=$BLD/src
    [ -d "$SRC" ] && case $SRC in "$BLD"/src) rm -rf -- "$SRC";; esac
    mkdir -p "$SRC"; cp -a "$APP"/. "$SRC"/ ;;
esac
rm -f "$BLD/CMakeCache.txt"
: > "$GAP_CLANG_LOG"
cd "$SRC"
cmake -S "$SRC" -B "$BLD" "${CM[@]}" "${PF[@]}" ${PACK_CMAKE_ARGS:-}
cmake --build "$BLD" -j "${JOBS:-8}"
n=$(grep -c . "$GAP_CLANG_LOG" || true)
echo "built $BLD/$(basename "$APP") ($V; $n commands went through the clang wrapper)"
