#!/usr/bin/env bash
# Small helpers the conductor calls. Each prints what it did.
#   scripts/wt.sh new <name> <branch> <base-ref>   worktree at wt/<name>, build dir build/<name>
#   scripts/wt.sh rm <name>                        remove a worker worktree (branch is kept)
#   scripts/wt.sh latest-tag <major>               final point release tag, e.g. llvmorg-19.1.7
#   scripts/wt.sh detach <name> <cmd...>           run cmd in background: logs/<name>.{log,pid,exit}
#   scripts/wt.sh status <name>                    RUNNING, or EXIT <code>
set -euo pipefail
source "$(dirname "$0")/../config.env"
cmd="${1:?}"; shift
case "$cmd" in
  new)
    name="$1"; branch="$2"; base="$3"
    git -C "$LLVM_SRC" worktree add -b "$branch" "$WT_ROOT/$name" "$base"
    mkdir -p "$BUILD_ROOT/$name"; echo "$WT_ROOT/$name $BUILD_ROOT/$name" ;;
  rm)
    git -C "$LLVM_SRC" worktree remove --force "$WT_ROOT/$1"; echo "removed $WT_ROOT/$1 (build dir kept for ccache-warm reuse)" ;;
  latest-tag)
    git -C "$LLVM_SRC" tag -l "llvmorg-$1.1.*" | grep -v -- -rc | sort -V | tail -1 ;;
  detach)
    name="$1"; shift; mkdir -p "$LOG_ROOT"; rm -f "$LOG_ROOT/$name.exit"
    nohup bash -c '"$@"; echo $? > "'"$LOG_ROOT/$name.exit"'"' _ "$@" > "$LOG_ROOT/$name.log" 2>&1 &
    echo $! > "$LOG_ROOT/$name.pid"; echo "started $name pid $(cat "$LOG_ROOT/$name.pid") log $LOG_ROOT/$name.log" ;;
  status)
    name="$1"
    if [ -f "$LOG_ROOT/$name.exit" ]; then echo "EXIT $(cat "$LOG_ROOT/$name.exit")";
    elif [ -f "$LOG_ROOT/$name.pid" ] && kill -0 "$(cat "$LOG_ROOT/$name.pid")" 2>/dev/null; then echo RUNNING;
    else echo "UNKNOWN (no exit file, process gone)"; fi ;;
  *) echo "unknown command $cmd" >&2; exit 2 ;;
esac
