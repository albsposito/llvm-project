#!/usr/bin/env bash
# Configure + build one GAP9 SDK CMake app with GCC or with our clang.
#   build_app.sh <app dir relative to the SDK> <variant> [extra cmake -D args...]
# variant: gcc | clang | clang-compat | clang-compat-gnuld | ... any name; the
# name only selects the defaults below, the GAP_CLANG_* env vars override them:
#   gcc*            GAP9 GCC (the SDK default)
#   clang*          our clang via clang-gap9.cmake
#   *-compat*       GAP_CLANG_COMPAT=1 (stop-gap builtins, gap9_clang_compat.h)
#   *-lenient*      GAP_CLANG_LENIENT=1
#   *-gnuld*        GAP_CLANG_LINKER=gnu (GNU ld of the GAP toolchain)
#   *-gnuas*        GAP_CLANG_AS=gnu (.S files assembled by GAP9 GCC)
#   *-nowerror*     -DCONFIG_DISABLE_WERROR=y
#   *-fp16probe*    GAP_CLANG_FP16PROBE=1 (probe only, see gap9_clang_compat.h)
#   *-sdkp*         use the patched mirror $W/sdkp (make_patched_mirror.sh:
#                   .S sources made LLVM-MC-compatible)
# Output: $W/bld/<app>__<variant>/ with cfg.log, build.log, the ELF, and
# clang-cmds.log (translated command lines).  Always targets GVSoC2
# (-DCONFIG_PLATFORM_GVSOC2=y) so `cmake --build <dir> -t run` runs it.
set -o pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
W=${SDK_CLANG_WORK:-/tmp/sdk-clang-work}
APP=$1; VAR=$2; shift 2
export GAP_RISCV_GCC_TOOLCHAIN=/home/ubuntu/gap_riscv_toolchain_ubuntu
source /home/ubuntu/gap_sdk_release/configs/gap9_evk_audio.sh >/dev/null 2>&1
M=$W/sdk
case $VAR in *-sdkp*) M=$W/sdkp;; esac
export GAP_SDK_HOME=$M
export GVSOC2_INSTALL_DIR=$W/gvsoc2-install
export PYTHONDONTWRITEBYTECODE=1
export PATH=$W/venv/bin:$GAP_RISCV_GCC_TOOLCHAIN/bin:$PATH
export GAP_CLANG_ROOT=${GAP_CLANG_ROOT:-$W/snap}
B=$W/bld/$(echo "$APP" | tr / _)__$VAR
rm -rf "$B"; mkdir -p "$B"
CM=()
case $VAR in clang*) CM+=(-C "$HERE/clang-gap9.cmake");; esac
case $VAR in *-compat*) export GAP_CLANG_COMPAT=${GAP_CLANG_COMPAT:-1};; esac
case $VAR in *-lenient*) export GAP_CLANG_LENIENT=${GAP_CLANG_LENIENT:-1};; esac
case $VAR in *-gnuld*) export GAP_CLANG_LINKER=${GAP_CLANG_LINKER:-gnu};; esac
case $VAR in *-fp16probe*) export GAP_CLANG_FP16PROBE=${GAP_CLANG_FP16PROBE:-1};; esac
case $VAR in *-gnuas*) export GAP_CLANG_AS=${GAP_CLANG_AS:-gnu};; esac
case $VAR in *-nowerror*) CM+=(-DCONFIG_DISABLE_WERROR=y);; esac
export GAP_CLANG_LOG=$B/clang-cmds.log
cd "$M/$APP" || exit 2
cmake -B "$B" "${CM[@]}" -DCONFIG_PLATFORM_GVSOC2=y -DPython_EXECUTABLE=$W/venv/bin/python \
      -DSFU=/bin/true "$@" > "$B/cfg.log" 2>&1
rc=$?; [ $rc = 0 ] || { echo "CONFIGURE FAILED ($B/cfg.log)"; exit 3; }
cmake --build "$B" -j ${JOBS:-8} -v -- -k > "$B/build.log" 2>&1
rc=$?
echo "build rc=$rc  ($B/build.log)"
exit $rc
