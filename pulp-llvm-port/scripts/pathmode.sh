# Sourced by build.sh and lit.sh (harness change 20/H005). Sets WT_RUN, WT_SRC and WT_BLD for a
# worktree/build-dir pair:
#  - fixed-path mode (new build dirs, and dirs configured under /work): commands run through
#    scripts/inwt.sh with the worktree at /work/src and the build dir at /work/build, so ccache
#    entries are shared across worktrees;
#  - legacy mode (build dirs configured before H005 with their real paths): unchanged behaviour.
pathmode() {
  local wt="$1" bd="$2" here; here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local home=""
  [ -f "$bd/CMakeCache.txt" ] && home=$(sed -n 's/^CMAKE_HOME_DIRECTORY:INTERNAL=//p' "$bd/CMakeCache.txt")
  if [ -z "$home" ] || [ "$home" = "/work/src/llvm" ]; then
    WT_RUN=("$here/inwt.sh" "$wt" "$bd"); WT_SRC=/work/src; WT_BLD=/work/build; WT_MODE=fixed
    # A fixed-path build dir no longer names its worktree in CMakeCache, so record it here and
    # refuse to build it from a different worktree (that would silently mix two trees).
    local real; real=$(realpath -e "$wt")
    mkdir -p "$bd"
    if [ -f "$bd/.worktree" ] && [ "$(cat "$bd/.worktree")" != "$real" ]; then
      echo "pathmode: $bd belongs to worktree $(cat "$bd/.worktree"), not $real" >&2; return 3
    fi
    printf '%s\n' "$real" > "$bd/.worktree"
  else
    WT_RUN=(); WT_SRC="$wt"; WT_BLD="$bd"; WT_MODE=legacy
  fi
}
