#!/usr/bin/env bash
# Run a command with a worktree at /work/src and its build dir at /work/build (harness change 20/H005).
#   scripts/inwt.sh <worktree> <build-dir> <cmd> [args...]
#
# Why: ccache keys on the compile command, and every worktree's command line contains its own path
# (wt/20-F004/...), so worker builds never hit the integration build's cache entries and each worker
# compiled clang from scratch (1.4% hit rate at step 20). Building every worktree at the same fixed
# paths makes identical sources produce identical commands, so ccache serves them.
#
# Each call gets a private mount namespace (unshare --mount), so concurrent builds of different
# worktrees do not see each other's /work mounts. sudo is used only for unshare/mount; the command
# itself runs as the calling user (setpriv), in the caller's working directory, with the caller's
# environment. Paths outside /work are unchanged, so output files under the harness root land
# where the caller expects.
set -euo pipefail
[ $# -ge 3 ] || { echo "usage: $0 <worktree> <build-dir> <cmd> [args...]" >&2; exit 2; }
wt=$(realpath -e "$1"); mkdir -p "$2"; bd=$(realpath -e "$2"); shift 2
[ -d /work/src ] && [ -d /work/build ] || { echo "inwt: /work/src and /work/build must exist (sudo mkdir -p)" >&2; exit 2; }
export INWT_UID="$(id -u)" INWT_GID="$(id -g)" INWT_PWD="$PWD"
exec sudo -n -E unshare --mount --propagation private -- bash -c '
  set -e
  mount --bind "$1" /work/src
  mount --bind "$2" /work/build
  shift 2
  cd "$INWT_PWD"
  exec setpriv --reuid="$INWT_UID" --regid="$INWT_GID" --init-groups -- "$@"
' _ "$wt" "$bd" "$@"
