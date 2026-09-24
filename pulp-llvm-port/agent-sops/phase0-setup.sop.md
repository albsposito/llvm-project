# Port Phase 0 Setup

## Overview

One-time preparation before the first port step: clone the fork with its remotes, restack it into one commit per cluster, build and test the untouched LLVM 18 fork to get the baseline every later step is compared against, and install it as the downstream oracle's reference toolchain. Run by the main Kiro session. Ends at a checkpoint the owner reviews before step 19 starts.

## Parameters

- **fork_url** (required): the owner's GitHub fork of `pulp-platform/llvm-project` (e.g. `git@github.com:<user>/llvm-project.git`), or `none` to clone from pulp-platform and add the fork later.

**Constraints for parameter acquisition:**
- If all required parameters are already provided, You MUST proceed to the Steps
- If any required parameters are missing, You MUST ask for them before proceeding
- When asking for parameters, You MUST request all parameters in a single prompt
- When asking for parameters, You MUST use the exact parameter names as defined

## Steps

### 1. Check prerequisites

**Constraints:**
- You MUST source `config.env`, run `docker image inspect pulp-llvm-builder:1` (build it with `docker build -t pulp-llvm-builder:1 -f docker/Dockerfile.builder docker` if missing), and run `scripts/in-builder.sh clang --version`
- You MUST check free disk on `/local` is at least 200 GB and call `resource_status`, and You MUST record both in `PROGRESS.md`
- You MUST run `python3 -m unittest discover -s tests` in the harness root and it MUST pass, because the landing gate depends on these scripts

### 2. Clone

**Constraints:**
- You MUST run `scripts/wt.sh detach clone scripts/setup-clone.sh <fork_url>` and poll until it exits 0; the clone is several GB
- You MUST confirm `git -C llvm-project rev-parse pulp/integer_SIMD_fix` equals `PULP_18_HEAD`; if it differs, You MUST stop and ask the owner, because the fork moved since this harness was written
- You MUST confirm `git -C llvm-project merge-base upstream/release/19.x pulp/integer_SIMD_fix` is reachable and `git merge-base --is-ancestor $PULP_18_MERGE_BASE pulp/integer_SIMD_fix` succeeds

### 3. Restack

**Constraints:**
- You MUST run `scripts/fork_anatomy.py map --repo llvm-project --base $PULP_18_MERGE_BASE --head pulp/integer_SIMD_fix` and it MUST exit 0 with the same 124 files as `data/fork-files-18.tsv`
- You MUST run `scripts/fork_anatomy.py restack --repo llvm-project --base $PULP_18_MERGE_BASE --head pulp/integer_SIMD_fix --branch port/18` and it MUST report `tree_identical_to_head: true`
- You MUST NOT modify `pulp/integer_SIMD_fix`, because it is the reference every change note is compared to

### 4. Baseline build and tests at 18

**Constraints:**
- You MUST check out the restacked branch in its own worktree with `git -C llvm-project worktree add ../wt/int-18 port/18` and `mkdir -p build/int-18`, then build detached with `scripts/build.sh wt/int-18 build/int-18 $JOBS_INTEGRATION`; it MUST succeed with zero errors
- You MUST run `scripts/lit.sh wt/int-18 build/int-18 $JOBS_INTEGRATION steps/18/lit-final`
- If `lit_diff.json` is not green, You MUST write the failing tests to `data/known-failures.txt` (one path per line, `# reason` after it, e.g. "fails on pristine fork at 18"), rerun lit, and list them for the owner in step 6, because a failure that already exists at 18 must not be charged to the port
- You MUST record the lit totals and the build time in `PROGRESS.md`

### 5. Reference toolchain

**Constraints:**
- You MUST build everything with `scripts/build.sh wt/int-18 build/int-18 $JOBS_INTEGRATION all`, install it with `scripts/in-builder.sh cmake --install build/int-18 --prefix /local/home/albsposi/pulp-llvm-port/toolchains/ref-18`, and confirm `toolchains/ref-18/bin/clang --target=riscv32-unknown-elf -march=rv32imc_xpulpv2 -c` compiles a one-line C file; if the `-march` string is rejected, You MUST find the accepted spelling in `llvm/lib/Support/RISCVISAInfo.cpp` on `port/18` and record it in `ORACLE.md`
- You MUST NOT delete `build/int-18`, because step 19's ccache and the baseline logs depend on it

### 6. Hand off

⚠️ MANDATORY OUTPUT STEP

**Constraints:**
- You MUST update `PROGRESS.md` (phase 0 done, baseline numbers, known failures) and record `phase: awaiting-owner` with `session_ledger_record`
- You MUST tell the owner: the restack result, the baseline lit totals, any known failures needing approval, and the two owner actions still open in `PROGRESS.md` (message to Luca Colagrande, oracle lane)
- You MUST NOT start step 19 until the owner approves, because the known-failures list becomes part of the definition of green

## Troubleshooting

### The clone is slow or times out
`setup-clone.sh` is idempotent; rerun it. It fetches only the fork branches, the upstream release branches 19 to 23, and tags.

### The 18 baseline fails to build in the container
The container's clang 18 may reject code the fork's CI built with GCC. Fix only with CMake flags (for example `-DLLVM_ENABLE_WERROR=OFF`, or a `-Wno-` flag) recorded in `scripts/build.sh`, never by editing the fork at 18, because the baseline must be the fork as published.
