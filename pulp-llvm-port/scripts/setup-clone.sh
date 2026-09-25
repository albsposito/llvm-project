#!/usr/bin/env bash
# One-time: clone the fork with three remotes and fetch only what the port needs.
#   scripts/setup-clone.sh <your-fork-url | none>
# 'none' clones from pulp-platform and leaves origin unset; add it later with
#   git -C llvm-project remote add origin <your-fork-url>
set -euo pipefail
source "$(dirname "$0")/../config.env"
fork="${1:?usage: setup-clone.sh <your-fork-url|none>}"
PULP=https://github.com/pulp-platform/llvm-project.git
UPSTREAM=https://github.com/llvm/llvm-project.git
if [ -d "$LLVM_SRC/.git" ]; then echo "clone already exists at $LLVM_SRC"; else
  git clone --no-checkout --single-branch --branch "$PULP_18_BRANCH" --origin pulp "$PULP" "$LLVM_SRC"
fi
cd "$LLVM_SRC"
git remote get-url pulp >/dev/null 2>&1 || git remote add pulp "$PULP"
git remote get-url upstream >/dev/null 2>&1 || git remote add upstream "$UPSTREAM"
[ "$fork" != none ] && { git remote get-url origin >/dev/null 2>&1 || git remote add origin "$fork"; }
git fetch pulp "$PULP_18_BRANCH" "$PULP_22_BRANCH"
for v in 19 20 21 22 23; do
  git fetch --no-tags upstream "release/$v.x:refs/remotes/upstream/release/$v.x" || echo "release/$v.x not found (yet)"
done
# Release tags (refspecs allow one '*', so fetch all llvmorg-* tags; their commits are
# already in the shared history, so this is cheap). Steps pin the final point release.
git fetch --no-tags upstream '+refs/tags/llvmorg-*:refs/tags/llvmorg-*'
git config rerere.enabled true
git config rerere.autoupdate true
git config feature.manyFiles true
git config merge.conflictStyle zdiff3
test "$(git rev-parse "pulp/$PULP_18_BRANCH")" = "$PULP_18_HEAD" \
  || echo "WARNING: pulp/$PULP_18_BRANCH moved since 2026-09-24 ($PULP_18_HEAD); update config.env deliberately"
git tag -l 'llvmorg-*' | grep -v rc | sort -V | tail -20
