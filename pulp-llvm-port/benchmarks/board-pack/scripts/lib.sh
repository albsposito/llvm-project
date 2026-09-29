# Shared shell functions of the board-pack scripts (sourced, not run).
PACK=${PACK:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}
RESULTS=${PACK_RESULTS:-$PACK/results}
BUILDS=${PACK_BUILDS:-$PACK/build}
PLATFORM=${PACK_PLATFORM:-board}          # board (default) or gvsoc
mkdir -p "$RESULTS" "$BUILDS"

pack_need_sdk() {
  [ -n "${GAP_SDK_HOME:-}" ] || { echo "GAP_SDK_HOME is not set: source your GAP9 SDK config first" >&2; exit 2; }
  command -v riscv32-unknown-elf-gcc >/dev/null || { echo "riscv32-unknown-elf-gcc is not on PATH" >&2; exit 2; }
}

# pack_run_build <name> <build dir>: run the SDK `run` target of an already built app,
# saving the program output to results/<name>.log.
pack_run_build() {
  local name=$1 bld=$2 log=$RESULTS/$1.log rc
  echo "---- running $name on the $PLATFORM (timeout ${PACK_TIMEOUT:-300}s) -> results/$name.log"
  { echo "[board-pack] test=$name platform=$PLATFORM date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"; } > "$log"
  timeout "${PACK_TIMEOUT:-300}" cmake --build "$bld" --target run 2>&1 | tee -a "$log"
  rc=${PIPESTATUS[0]}
  echo "[board-pack] run exit code: $rc" | tee -a "$log"
  grep -q '^=== END \|^Bye !\|^Done\.' "$log" ||
    echo "[board-pack] WARNING: no end marker in the output: the program hung, crashed or timed out" | tee -a "$log"
  return 0
}

# pack_build_fail <name> <build log>
pack_build_fail() {
  echo "[board-pack] BUILD FAILED for $1, see $2" | tee "$RESULTS/$1.log"
  cp "$2" "$RESULTS/$1.build-failed.log" 2>/dev/null || true
}

# pack_test <name> <test dir> [cmake -D...]: build a pack test from source and run it.
pack_test() {
  local name=$1 dir=$2; shift 2
  local bld=$BUILDS/$name
  "$PACK/scripts/build.sh" "$dir" "$PLATFORM" "$bld" "$@" > "$bld.build.log" 2>&1 || { pack_build_fail "$name" "$bld.build.log"; return 0; }
  pack_run_build "$name" "$bld"
}

# pack_prebuilt <name> <elf>: run a prebuilt ELF through the runner app (the local SDK builds the
# runner, then its ELF is replaced by <elf> before the `run` target loads it).
pack_prebuilt() {
  local name=$1 elf; elf=$(cd "$(dirname "$2")" && pwd)/$(basename "$2")
  local bld=$BUILDS/runner-$name
  "$PACK/scripts/build.sh" "$PACK/common/runner" "$PLATFORM" "$bld" -DPACK_PREBUILT_ELF="$elf" > "$bld.build.log" 2>&1 ||
    { pack_build_fail "$name" "$bld.build.log"; return 0; }
  cmp -s "$elf" "$bld/pack_runner" || { echo "[board-pack] ELF replacement failed for $name" | tee "$RESULTS/$name.log"; return 0; }
  pack_run_build "$name" "$bld"
}

# pack_t7 <name> <app dir> <variant>: build with t7_sdk_apps_clang/build_clang_app.sh and run.
pack_t7() {
  local name=$1 app=$2 v=$3 bld=$BUILDS/$1
  "$PACK/t7_sdk_apps_clang/build_clang_app.sh" "$app" "$PLATFORM" "$bld" "$v" > "$bld.build.log" 2>&1 ||
    { pack_build_fail "$name" "$bld.build.log"; return 0; }
  pack_run_build "$name" "$bld"
}
