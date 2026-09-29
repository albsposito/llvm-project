#!/usr/bin/env bash
# Build one board-pack test with the GAP9 SDK's normal CMake flow.
#   scripts/build.sh <test dir> [board|gvsoc] [build dir] [extra cmake -D options...]
# Needs the SDK environment (source <sdk>/configs/<your board>.sh, which sets GAP_SDK_HOME).
# Default build dir: <test dir>/build-<platform>. The ELF is <build dir>/<test name>.
set -eo pipefail
[ $# -ge 1 ] || { sed -n 2,5p "$0"; exit 2; }
T=$(cd "$1" && pwd); P=${2:-board}; B=${3:-$T/build-$P}
shift; [ $# -gt 0 ] && shift; [ $# -gt 0 ] && shift
[ -n "$GAP_SDK_HOME" ] || { echo "GAP_SDK_HOME is not set: source your GAP9 SDK config first" >&2; exit 2; }
case $P in
  board) PF=(-DCONFIG_PLATFORM_BOARD=y) ;;
  gvsoc) PF=(-DCONFIG_PLATFORM_GVSOC2=y) ;;
  *) echo "platform must be board or gvsoc" >&2; exit 2 ;;
esac
cd "$T"
cmake -S "$T" -B "$B" "${PF[@]}" ${PACK_CMAKE_ARGS:-} "$@"
cmake --build "$B" -j "${JOBS:-8}"
echo "built: $B/$(basename "$T")"
