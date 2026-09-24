# PULP LLVM port: reference guide

What the port is, how the fork is shaped, and where to look when something breaks. Agents read this after `AGENT_RULES.md`. The procedures live in `agent-sops/`; state lives in `PROGRESS.md`.

## 1. Goal and definition of done

Port the PULP LLVM fork `pulp-platform/llvm-project` branch `integer_SIMD_fix` (head `6547028f`, LLVM 18, 67 commits, +16,960 / -18 lines in 124 files) to LLVM 23, keeping every codegen feature it has: Xpulpv2 packed SIMD lowering, hardware loops, post-increment memory ops, MAC, clang `__builtin_pulp_*` builtins, Snitch SSR/SDMA/FREP (including `#pragma frep infer`), Xsmallfloat.

A version step is done when all of these hold (the conductor checks them in `agent-sops/port-step.sop.md`, step 6):

- clean build of `clang lld llc llvm-mc opt llvm-objdump` with assertions on;
- `scripts/lit.sh` green: every test in `LIT_PATHS` passes, every fork test in `data/fork-tests.txt` runs and passes, nothing that passed at the previous step regressed;
- RISCVISAInfo unit tests pass;
- `policy_check.py` has no FAIL over the whole step;
- the stack is back to one commit per cluster;
- once the downstream oracle exists (`ORACLE.md`), its Xpulpv2 lane is green.

The port is done when step 23 meets all of these and the owner has reviewed the step reports.

## 2. Route

| Route | What | Verdict |
|---|---|---|
| 1 | Rebase `integer_SIMD_fix` release by release 18 to 19, 20, 21, 22, 23 | Recommended start |
| 2 | Same as route 1 up to 22, then move the codegen layers onto PULP's `llvmorg-22.1.7-pulp` at the same LLVM version (so no API drift in that step, only instruction naming), then 22 to 23 | Open, decided at the 22 checkpoint (decision D1 in `PROGRESS.md`) |
| 3 | Move the 18 codegen straight onto `llvmorg-22.1.7-pulp` | Rejected: mixes four releases of API change with instruction renaming in one step with no green checkpoint in between, so a failing test cannot be traced to a cause |

Routes 1 and 2 are identical until step 22 is green, so nothing blocks starting. Facts that feed D1: `llvmorg-22.1.7-pulp` is MC-only (instruction encodings auto-generated from `riscv-opcodes`, no ISel patterns, intrinsics, builtins, passes or tests) and has no hardware-loop or PULP post-increment encodings at all (verified against the branch files 2026-09-24). Route 2 therefore still carries those two families' encodings from the 18 fork, and needs the ISel patterns split out of the instruction `.td` files. Ask Luca Colagrande (maintainer of the 22 branch) what he plans before choosing.

Step bases: the final point release of each branch, resolved at step start with `scripts/wt.sh latest-tag <N>`. Exception: step 22 uses `llvmorg-22.1.7` whatever the latest is, because that is the base of PULP's 22 branch and route 2 needs both at the same commit.

## 3. Fork anatomy

The fork is restacked once (Phase 0) into one commit per cluster, in this order. `data/clusters.json` holds the path rules; `scripts/fork_anatomy.py owner <path>` answers "which cluster owns this file". All 124 fork files map to exactly one cluster (checked by `tests/test_harness.py`).

| Cluster | Files | Lines | Contents | Conflict risk per step |
|---|---|---|---|---|
| registration | 7 | +163 | `RISCVFeatures.td`, `RISCVProcessors.td`, CSRs, `RISCVISAInfo.cpp` extension table and its unit test | High at 19 (ISAInfo relocation), low after |
| insn-tablegen | 9 | +4,179 | `RISCVInstrInfoX{pulp,smallfloat,smallfloatGen,ssr,dma,frep}.td`, Mempool/Snitch sched models | Low (new files), loud TableGen errors when base classes change |
| intrinsics | 4 | +492 | `IntrinsicsRISCVXpulp.td`, `IntrinsicsRISCVXsnitch.td`, SelectionDAG node defs | Low |
| codegen-core | 11 | +448 | `RISCVISelLowering`, `RISCVISelDAGToDAG`, `RISCVInstrInfo.cpp`, register info, TTI | High every step (most edited RISC-V files upstream) and the main semantic risk (v4i8/v2i16 legal on RV32) |
| passes | 9 | +4,944 | `PULP/PULPHardwareLoops.cpp`, `PULP/PULPFixupHwLoops.cpp`, `Snitch/SNITCHFrepLoops.cpp`, SSR/SDMA/pseudo expansion, pass registration | Medium: API drift in new files, pipeline hook changes |
| mc | 9 | +145 | asm parser, disassembler, encoder, fixups, ELF relocation, lld | Medium: MC fixup API refactored around 20 and 21 |
| clang-builtins | 3 | +320 | `BuiltinsRISCV.def`, Sema checks, diagnostics | High at 19 (both files relocate) |
| clang-frep-pragma | 10 | +295 | `#pragma frep` parser, attribute, CGStmt | Low to medium |
| clang-driver | 5 | +29 | target macros, `-mno-fdiv` style flags | Low |
| tests | 56 | +5,699 | fork lit tests, pipeline expectations (`O0/O3-pipeline.ll`) | Pipeline tests need regeneration every step |
| docs | 1 | +246 | fork README | None |

`RISCVInstrInfoXsmallfloatGen.td` is generated (by its name); look for the generator in the fork before porting it by hand, and regenerate instead.

## 4. What breaks, by step (leads to verify, not facts)

The list below is from memory of the upstream release notes. The conductor's recon step (port-step step 1) MUST verify each lead against `llvm/docs/ReleaseNotes.md` and `clang/docs/ReleaseNotes.rst` at the step's tag and against the upstream commit, and record the verified list in `steps/<N>/leads.md`. Workers use the verified file, never this table.

| Step | Leads |
|---|---|
| 19 | Debug info moved from `llvm.dbg.*` intrinsics to debug records (passes that walk or clone instructions); `RISCVISAInfo.cpp` moved from `lib/Support` to `lib/TargetParser` and its extension table became TableGen-generated from `RISCVFeatures.td`; `BuiltinsRISCV.def` became a `.td`; RISC-V builtin checks moved from `SemaChecking.cpp` to `SemaRISCV.cpp` (Sema split); more `ConstantExpr` kinds and `getInt8PtrTy` family removed |
| 20 | `Intrinsic::getDeclaration` renamed `getOrInsertDeclaration`; `TargetTransformInfo` signature changes; MC fixup and relocation refactors begin |
| 21 | Uses of `ConstantData` can no longer be inspected (`use_empty()` always true, compiles and silently changes behaviour); `TargetIntrinsicInfo` removed; further MC refactors |
| 22 | New `ptrtoaddr` instruction (exhaustive opcode switches need a case); alignment of masked gather/scatter moved from operand to attribute |
| 23 | Unknown: read the release notes first |
| every step | New pass manager migration in codegen (pass registration, `RISCVPassConfig` hooks), RISC-V base class renames in TableGen, `llc` output drift in pipeline and FileCheck tests |

## 5. How to research a break

Run these in the main clone (`$LLVM_SRC`), which has all upstream release branches and tags:

- Who removed a symbol: `git log -S'getDeclaration' --oneline <prev-tag>..<tag> -- llvm/include llvm/lib`
- Who changed a pattern of use: `git log -G'<regex>' --oneline <prev-tag>..<tag> -- <path>`
- Where a file went: `git log --follow --name-status --oneline <prev-tag>..<tag> -- <old path>`, or `git log --diff-filter=R --summary <prev-tag>..<tag> | grep <file name>`
- How upstream did the same thing: look at the CORE-V `XCV*` code (`RISCVInstrInfoXCV.td`, `XCV` entries in `RISCVFeatures.td`, `RISCVISelLowering.cpp`, `SemaRISCV.cpp`) and at other RISC-V vendor extensions (`XTHead*`, `XSf*`) at the step's tag.
- Release notes at the tag: `git show <tag>:llvm/docs/ReleaseNotes.md`, `git show <tag>:clang/docs/ReleaseNotes.rst`.

Never search the whole repository history without a range; LLVM has hundreds of thousands of commits.

## 6. Roles

| Role | Runs as | Does | Output |
|---|---|---|---|
| conductor | the main Kiro session | runs `agent-sops/port-step.sop.md`, owns the integration worktree, dispatches everyone else, lands changes, keeps `PROGRESS.md` | step report, tags |
| conflict resolver | subagent, one at a time | resolves one cherry-pick conflict in the integration worktree while the step's stack is being applied | resolved commit, `notes/<N>/conflict-<cluster>.md` |
| worker | subagent, up to `MAX_WORKERS` in parallel | fixes one error cluster or one test group in its own worktree | `work/<N>/<task>` branch, change note, `tasks/<N>/<task>.result.json` |
| reviewer | subagent, never the same run as the worker | checks one worker branch against `AGENT_RULES.md` and its change note | `tasks/<N>/<task>.review.json` (APPROVE or REJECT with reasons) |
| test-regen | worker with role `test-regen` | regenerates CHECK lines with LLVM's update scripts and classifies every change | regen report |

## 7. Names and places

| Thing | Name |
|---|---|
| Harness (this repo) | `/local/home/albsposi/pulp-llvm-port` |
| Main clone (not built in) | `llvm-project/` with remotes `pulp`, `upstream`, `origin` (owner's GitHub fork) |
| Restacked 18 fork | branch `port/18` |
| Integration branch for step N | `port/<N>`, worktree `wt/int-<N>`, build dir `build/int-<N>` |
| Worker branch | `work/<N>/<task-id>`, worktree `wt/<N>-<task-id>`, build dir `build/<N>-<task-id>` |
| Green checkpoint | tag `port-<N>-green` on `port/<N>` |
| Task files, results, reviews | `tasks/<N>/` |
| Change notes, conflict notes, regen reports | `notes/<N>/` |
| Verified leads, error clusters, lit reports, step report | `steps/<N>/` |
| Logs | `logs/` |

Only the conductor pushes, and only `port/*` branches and `port-*-green` tags to `origin` (the owner's fork), after the owner has approved the step.

## 8. Build facts

- The host compiler (gcc 7.3.1 on Amazon Linux 2) is below LLVM's minimum, so every build and lit run happens in the `pulp-llvm-builder:1` container (Ubuntu 24.04, clang 18, ninja, ccache, cmake 3.28). `scripts/in-builder.sh` runs a command in it with the harness directory mounted at the same path.
- Configuration: Release, assertions on, `LLVM_TARGETS_TO_BUILD=RISCV`, `LLVM_ENABLE_PROJECTS=clang;lld`, default triple `riscv32-unknown-elf`, ccache shared across worktrees (`CCACHE_BASEDIR` is the harness root, so identical sources hit across worktrees).
- The first build of a worktree is the slow one; later builds are incremental. Run anything longer than a few minutes with `scripts/wt.sh detach <name> <cmd>` and poll `scripts/wt.sh status <name>`.
- Useful partial targets for workers: `LLVMRISCVCodeGen`, `LLVMRISCVDesc`, `LLVMRISCVAsmParser`, `LLVMRISCVDisassembler`, `LLVMTargetParser`, `obj.clangSema`, `obj.clangParse`, `obj.clangCodeGen`, `llc`, `clang`.
