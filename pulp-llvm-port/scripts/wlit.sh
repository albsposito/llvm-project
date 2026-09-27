#!/usr/bin/env bash
# Run llvm-lit for a worktree's build dir, in either path mode (harness change 20/H005).
#   scripts/wlit.sh <worktree> <build-dir> [lit options...] <test paths relative to the worktree...>
# A fixed-path build dir's lit config refers to /work/src and /work/build, so lit must run inside
# scripts/inwt.sh; this wrapper does that and maps worktree-relative test paths. The built tools
# themselves (clang, llc, FileCheck, ...) can be run directly from <build-dir>/bin anywhere.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
wt="$1"; bd="$2"; shift 2
source "$here/pathmode.sh"; pathmode "$wt" "$bd" || exit 3
args=()
for a in "$@"; do
  if [[ "$a" != -* && -e "$wt/$a" ]]; then args+=("$WT_SRC/$a"); else args+=("$a"); fi
done
exec "${WT_RUN[@]}" "$WT_BLD/bin/llvm-lit" "${args[@]}"
