# Backlog: open problems

The single list of everything still to be addressed on the PULP LLVM port. Created 2026-09-27 from the escalations table in `PROGRESS.md`, the GAP9 benchmark reports and tonight's reviews. Rules:

- Every open problem gets one entry here, found anywhere (worker, reviewer, benchmark, owner).
- When an item is fixed, move it to **Done** at the bottom with the commit/task that fixed it; never delete it.
- Priority: **P1** wrong results, crashes, or a blocker for the next step; **P2** performance gaps vs GAP9 GCC or missing features users need; **P3** hygiene, coverage, low-impact edge cases.
- Status: `open`, `in progress (task)`, `in review (task)`, `waiting on owner`, `planned (step N)`.

Evidence paths are relative to `pulp-llvm-port/`.

## P1: correctness and blockers

| ID | Problem | Evidence | Status |
|---|---|---|---|
| B01 | **Hardware-loop trip counts can be wrong.** `computeCount` in `PULPHardwareLoops.cpp` ignores the comparison kind and branch direction (the fork dropped Hexagon's `Negated` handling): `icmp sge` bounds give n-m instead of n-m+1 on ref-18 and port-20; after F003 some `$x0` shapes (BEQ to header, BGE) miscount. C at -O2 did not produce them in tests, but hand-written or other code can. | `tasks/20/F003.review.json` | interrupted 2026-09-27 (20/F007 not started; re-dispatch) |
| B02 | **do/while hardware loops have no zero/negative trip guard** (`loopCountMayWrapOrUnderFlow` is commented out): `do{}while(--i>=0)` with n=-5 hangs, `++i<m` with n>m hangs; same on ref-18. | `tasks/20/F003.review.json` | interrupted 2026-09-27 (20/F007 not started; re-dispatch) |
| B03 | **Two `lp.setup` for one loop after tail duplication** (fuzz seed 27): two setups with different end labels in front of the same loop. | `tasks/20/F003.review.json`, `benchmarks/hwloop-fuzz/` | open |
| B04 | **Remaining PULP Hardware Loops crashes on random C loops.** After F003 the fuzzer still finds crashes (e.g. float fuzz seed 379 in `convertToHardwareLoop`); run the fuzzer to size it. | `tasks/20/F006.result.json`, `benchmarks/hwloop-fuzz/` | open |
| B05 | **Machine-verifier errors after the hardware-loop fixup pass** (`xpulp-hwloop.ll -verify-machineinstrs`): blocks the pass creates have no live-in registers, and the loop-setup instruction is unanalyzable as a branch. Pre-existing at 19. Can hide real bugs. | `tasks/20/T007.result.json`, `tasks/20/F005.result.json` | open |
| B06 | **FREP body integrity not guaranteed.** `frep.o/i` are now scheduling boundaries (T003), but nothing stops the scheduler mixing an unrelated instruction into the repeated body. Fix: bundle `frep` with its body or end the scheduling region after the Nth instruction; add a test with an independent-instruction body. | `tasks/20/T003.review.json` | open |
| B07 | **PULP immediate branches can be rebuilt as the wrong instruction.** The fork maps `P_BEQIMM`/`P_BNEIMM` to plain EQ, so a rebuilt branch can become `BEQ` reading the immediate as a register; at 21 upstream's refactor makes them hit `llvm_unreachable`, at 23 `getInverseBranchOpcode` does too. Upstream fixed the same bug for CORE-V in `0439a4eca78f`. | PROGRESS.md escalations; `steps/21/leads.md`, `steps/23/leads.md` | interrupted 2026-09-27 (20/F009: uncommitted edits in wt/20-F009; retry) |
| B08 | **Step 21 silent hardware-loop breaks** (pre-flagged): PC-relative flag moved to the fixup (loop fixups must set `PCRel=true`), and relocation forcing redesigned (`shouldForceRelocation` removed: with relaxation, `R_PULPV2_LOOP_SETUP(I)` may be emitted and lld maps it to R_NONE). Verify with objdump at -mrelax and -mno-relax. | `steps/21/leads.md` | planned (step 21) |
| B09 | **Step 21: fork `isLoweredToCall` no longer overrides** the now-const TTI method (`bb1765179e1f`): compiles, but PULP intrinsics are treated as calls, silently changing cost and hardware-loop decisions. | `steps/21/leads.md`, `steps/23/leads.md` | planned (step 21) |
| B10 | **Step 23 silent/late breaks** (pre-flagged): lld skips `getRelExpr` for RISC-V (hardware-loop relocations fail to link); `-mtune=generic` now uses the SpacemitX60 model and select optimisation is on (shifts 52 of 56 fork tests, may change hardware-loop formation); asm near-miss diagnostics change 6 `-invalid.s` tests; ABI hunk moves to `CC_RISCV_Impl`. | `steps/23/leads.md` | planned (step 23) |
| B11 | **Hand-written assembly with hardware-loop labels is broken** in every version: `lp.setupi` with a label is rejected, `lp.setup`/`lp.starti`/`lp.endi` with a label crash the assembler ("Unknown match type detected!"). Matters for DSP code written in assembly. | `tasks/20/R001.result.json` | interrupted 2026-09-27 (20/F010: uncommitted edits in wt/20-F010, bug reproduced; retry) |
| B12 | **Builtin range checks weaker than GCC's**: `__builtin_pulp_clip` does not require lo == -(hi+1); clip/clipu accept hi above 2^30-1 (immediate 32 does not fit, silently encodes 0); bextract accepts Size=0 (now an ISel "Cannot select"). Behaviour change: fork tests call `clip(-10,-4,15)`, so it needs an owner decision on those tests. | `tasks/20/F002.result.json`, `tasks/20/F002.review.json` | interrupted 2026-09-27 (20/F011: uncommitted edits in wt/20-F011; retry; owner approved) |
| B13 | **The published `port/19` branch has a hardware-loop miscompile** (k05 MatMul DSP -O2 runs 2x the work, and the fixup-pass wrong results confirmed on ref-18/port-19/port-20). port/20 with F005 fixes it. Decide whether to note it on the published branch or push the fixed port/20. | PROGRESS.md escalations; `tasks/20/F005.review.json` | waiting on owner |

## P2: performance gaps vs GAP9 GCC, and missing features

| ID | Problem | Evidence | Status |
|---|---|---|---|
| B20 | **MatVect float +32.7% slower than GCC: no load-and-advance in its unrolled loop.** LLVM's hot loop reads one pointer at two offsets (-4 and 0) then adds 8; LLVM forms post-increment one load at a time and declines when the pointer has other users (also for integer data). GCC uses four separate pointers, each `p.lw ...(ptr!)`, 3 instructions per multiply-add vs LLVM's 5. Fix: make loop strength reduction (or a PULP DAG combine) give each access stream its own pointer when post-increment is available; measure against MatVect (k06); integer code will change too. (MatMul float, which had the same symptom, was closed by F006: 175,559 -> 142,791 cycles, GCC 143,874.) | `benchmarks/gap9-sweep/runtime/runtime_report.md`, `tasks/20/F006.result.json`, `tasks/20/F006.review.json` | open |
| B22 | **Missed nested hardware loops**: GCC nests two levels in MatVect (and elsewhere), LLVM forms one; inner loops without a preheader are declined. | `tasks/20/F003.result.json`, runtime disassembly | open |
| B23 | **Missed hardware loops on simple loops**: copy +74.9%, packed add +59.7% vs GCC; the pass declines constant-count loops ending in a "not equal" test. | `tasks/20/F003.result.json`, runtime report | open |
| B24 | **Plain-C clamps never become one `p.clip`/`p.clipu`**: the fork's patterns use `TImmLeaf`, which never matches an ordinary constant; clip kernel +23.5% vs GCC. | `tasks/20/F002.result.json` | interrupted 2026-09-27 (20/F008: 1 unverified commit on work/20/F008, no result file; retry) |
| B25 | **MatMul int16 +9.0% vs GCC, not analysed** (about 10,000 more retired instructions per call). | runtime report | open |
| B26 | **At -O3 GCC improves FIR f32 and FFT, LLVM does not** (FIR f32 39,665 vs 37,677; FFT 22,807 vs 21,799). | runtime report | open |
| B27 | **Tiny kernels +18% vs GCC**: 2-3 extra cycles per call around one-operation functions (driver call loop and call overhead). Low value per case, but indicates call/loop overhead worth a look. | runtime report | open |
| B28 | **GAP9 ISA gap vs GCC**: 43 of the 182 `__builtin_pulp_*` builtins the GAP9 headers use are missing (complex arithmetic, `.divN`, Int64, fractional multiply, f16/f32 helpers, e.g. `__builtin_pulp_add2div2`, `__builtin_pulp_mul64hu`); fp16 vector instructions (Xfvec); `float16alt`; the `-march=...xgap9` spelling and cluster options (`-mPE`, `-mFC`); GCC-only language features (`__builtin_shuffle`). The SIMD FFT (k10b) and `MathFuncsFix.c` fail on these. | `benchmarks/gap9-sweep-survey.md` | open |
| B29 | **SDK build integration with clang**: the SDK build hard-codes GCC; clang needs a toolchain switch, startup code, linker scripts and runtime libraries; PMSIS, the GreenWaves runtime and AutoTiler-generated code must compile. | `benchmarks/gap9-sweep-survey.md` | open |
| B30 | **Full SDK compile survey** to turn the parity estimate into a counted inventory: build all examples, PMSIS and AutoTiler output with our clang and bucket every failure by cause. | chat 2026-09-27 | open |

## P3: coverage, tests, hygiene, edge cases

| ID | Problem | Evidence | Status |
|---|---|---|---|
| B40 | **Proposed regression tests awaiting owner decision** (each task's result file has a `proposed_test`): F001 (RN-builtin Sema), F002 (exact p.clip/p.extract immediates), F003 (count-down hardware loops), F004 (packed-SIMD cost model), F005 (rotated/multi-exit hardware-loop layout), F006 (f32 post-increment), R001 (object emission of `lp.setupi`, incl. an x1-level case), E007 (Xpulpv2 post-increment preference). Several fixed bugs are otherwise unguarded by lit (e.g. the edited RN tests pass with or without F001). | `tasks/20/*.result.json` | interrupted 2026-09-27 (20/T010 not started; re-dispatch; owner approved) |
| B41 | **Known failure** `llvm/test/CodeGen/RISCV/rvv/vsetvli-insert-zve64f.mir` (fork register classes shift RC IDs). Removed by the step-23 register-class redesign (B42). | `data/known-failures.txt`, `notes/20/owner-test-exceptions.md` | planned (step 23) |
| B42 | **Remove the `GPRAV2`/`GPRAV4` (ex-PulpV2/V4) register classes** in favour of upstream's P-extension approach (v2i16/v4i8 in GPR, `isPExtPackedType`); ends the name-order bridge (D3). | `notes/20/owner-test-exceptions.md`, PROGRESS.md D3 | planned (step 23) |
| B43 | **Xpulpv2 + XCVmem ordering**: ISel tries PULP post-increment before XCVmem, `getPostIndexedAddressParts` returns early for XCVmem. Only matters with both extensions. | PROGRESS.md escalations | open |
| B44 | **Xpulpv2 + V calling convention**: RVV argument dispatch vs PULP packed vectors in GPRs; `CC_RISCV_FastCC` has no PULP case (gap since 18). Only with V and Xpulpv2 together. | PROGRESS.md escalations | open |
| B45 | **Machine pipeliner and Zicfilp untested with PULP/FREP passes**; no upstream equivalent establishes combined compatibility. | PROGRESS.md escalations | open |
| B46 | **Wide fixed vectors under Xpulpv2 get cost 1** (F004 follows upstream P-extension guards; `<16 x i8>` underestimated; would override RVV costs if V were enabled with Xpulpv2). | `tasks/20/F004.review.json` | open |
| B47 | **GAP9 GCC 7.1.1 is not a perfect oracle**: it miscompiles `do{c++;}while(--i>0)` at -O2 (returns 1 for n = 2..100). Keep host cross-checks in the benchmark harness. | `tasks/20/F003.review.json` | open (note) |
| B48 | **Stale `static` removal in two extracted benchmark kernels** (`matmul_worker`, `MatMulSimpleSeq`) can affect inlining equally for all compilers; revisit if exact per-kernel numbers matter. | chat 2026-09-27 | open (note) |

## Project decisions and owner actions still open

| ID | Item | Status |
|---|---|---|
| B60 | **D1**: at the 22 checkpoint, route 1 (own lineage to 23) or route 2 (move codegen onto `llvmorg-22.1.7-pulp`). Facts in `steps/22/leads.md` ("Facts for D1"). | waiting on owner (due at 22) |
| B61 | **D2**: downstream oracle. The GAP9 SDK sweep on GVSoC now exists (`benchmarks/gap9-sweep/`); decide whether it becomes a required gate at every step. | waiting on owner |
| B62 | **Message Luca Colagrande** about the codegen layers and the 22 branch before step 22. | waiting on owner |
| B63 | **Push the fixed `port/20`**: F001-F006 and R001 are landed locally on `port/20` after the pushed `port-20-green`; not yet on GitHub. | done 2026-09-27: port/20 pushed |
| B64 | **Steps 21, 22, 23** of the port. Paused for owner evaluation after step 20. | waiting on owner |

## Done (moved here when fixed)

| ID | Problem | Fixed by |
|---|---|---|
| — | p.clip / p.extract[u] immediate off-by-one (wrong results since 18) | 20/F002 |
| — | False "vector length without Zve or V" assertion on packed SIMD | 20/F004 |
| — | `lp.setupi` object-emission crash (step-20 regression) | 20/R001 |
| — | RN-builtin Sema check rejected valid calls | 20/F001 + T009 |
| — | PULP Hardware Loops crash on `$x0` exit compares (6 of 7 failing SDK kernels) | 20/F003 |
| — | Hardware-loop fixup crash and silent miscompiles on rearranged loops (since 18) | 20/F005 |
| — | FREP miscompile from bidirectional pre-RA scheduling | 20/T003 + T008 |
| — | GPR / PulpV2 / PulpV4 subclass relation lost at 20 | 20/T007 (bridge, see B42) |
| B21 | Float load-and-advance for simple loops (f32 post-increment `p.lw` under Xpulpv2+Zfinx; float dot product now equals GCC, MatMul float now 0.8% faster than GCC; stores deliberately not enabled) | 20/F006 (also on branch `f32-postinc-20`) |
