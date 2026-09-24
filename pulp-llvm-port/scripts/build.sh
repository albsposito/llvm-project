#!/usr/bin/env bash
# Configure (first time) and build a worktree in the build container.
#   scripts/build.sh <worktree> <build-dir> <jobs> [ninja targets...]
# Default targets are the tools the lit suite and the oracle need. ninja runs with -k 0
# so one build reports every error (cluster_errors.py needs all of them, not the first).
set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
wt="$1"; bd="$2"; jobs="$3"; shift 3
targets=("$@")
[ ${#targets[@]} -eq 0 ] && targets=(clang lld llc llvm-mc opt llvm-objdump)
mkdir -p "$bd"
"$here/in-builder.sh" bash -c '
set -uo pipefail
wt="$1"; bd="$2"; jobs="$3"; shift 3
if [ ! -f "$bd/build.ninja" ]; then
  cmake -G Ninja -S "$wt/llvm" -B "$bd" \
    -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_TARGETS_TO_BUILD=RISCV -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_DEFAULT_TARGET_TRIPLE=riscv32-unknown-elf \
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_USE_LINKER=lld \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DLLVM_PARALLEL_LINK_JOBS=2 -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_DOCS=OFF || exit 2
fi
ninja -C "$bd" -j "$jobs" -k 0 "$@"
' _ "$wt" "$bd" "$jobs" "${targets[@]}"
