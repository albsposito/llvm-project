# Progress

Durable state of the port. The conductor updates this file at the end of every SOP step; after a context reset it is read before anything else.

Current phase: **PAUSED for owner overnight checkpoint — Step 20, build r1 triaged**. Integration port/20 remains `94bbab7f1554874b4f17e51bbdadef698136489f`; build r1 finished rc=1. E001 worker commit `963f162ed285` fixes the smallfloat constructor root cause (three coalesced diagnostics), awaits independent review and integrate.py landing; exposes scheduling resource WriteFCvtF32ToF16. H003 `245805561951` independently APPROVED but not applied to main harness. LLVM19 GREEN at port-19-green. Benchmark complete. See HANDOVER.md for exact resume procedure. No builds running; owner requested commit/push and resume next session.

## Steps

| Step | Base tag | Status | Stack tip | Rounds (build / test) | Landed | Escalated | Green tag | Owner approved |
|---|---|---|---|---|---|---|---|---|
| 18 baseline | merge base `e6c32898` | green | `1c33bd3d` (restacked, tree identical to `6547028f`) | build 505 s cold (24 jobs), 0 errors; lit 4023/4023 PASS, 56/56 fork lit tests, RISCVISAInfo unit 37/37 | | | (baseline, no tag) | 2026-09-24 (standing instruction) |
| 19 | `llvmorg-19.1.7` | green | `9b2edaf923ad` | build 2 recorded / test 1 | 15 E/T tasks, 16 fixup commits | 3 codegen-core questions open | `port-19-green` | Standing authorization; report available 2026-09-25 |
| 20 | `llvmorg-20.1.8` | build r1 | `94bbab7f1554` | | | 4 recorded design questions | | Standing continuation authorized |
| 21 | `llvmorg-21.1.8` | not started | | | | | | |
| 22 | `llvmorg-22.1.7` (pinned) | not started | | | | | | |
| 23 | `llvmorg-23.1.2` | not started | | | | | | |

## Decisions

| ID | Decision | Status |
|---|---|---|
| D0 | Start with route 1 (release-by-release rebase of `integer_SIMD_fix`); routes 1 and 2 are identical until 22 | Decided 2026-09-24 |
| D1 | At the 22 checkpoint: continue on own lineage to 23 (route 1), or move the codegen layers onto `llvmorg-22.1.7-pulp` (route 2) | Open, due at 22. Inputs: Luca Colagrande's plans, which extension families matter at 23, whether `riscv-opcodes` has hardware-loop and post-increment encodings |
| D2 | Oracle lane runner: build the Xpulpv2 lane before step 19 finishes, or run steps on lit only until it exists | Open |

## Owner actions

- [x] Fork `pulp-platform/llvm-project` under your personal GitHub account (`albsposito/llvm-project`, 2026-09-24), then run Phase 0 with its URL
- [ ] Message Luca Colagrande about the codegen layers and the 22 branch before step 22 at the latest
- [ ] Decide D2
- [ ] Review each step report and approve (the only human check in the loop)

## Host

Current host (2026-09-24): Ubuntu 24.04, 32 cores, 123 GB RAM, 478 GB free on `/`. No Docker; the builder image's toolchain is installed natively instead (clang/lld 18.1.3, ninja 1.11.1, ccache 4.9.1, cmake 3.28.3, same versions as `pulp-llvm-builder:1`), and `BUILDER_IMAGE` is empty in `config.env` so `scripts/in-builder.sh` runs commands directly. The harness lives inside the owner's fork checkout `/home/ubuntu/llvm-project`, which serves as `LLVM_SRC` (remotes `origin` = owner fork, `pulp`, `upstream`).

Phase 0 facts (2026-09-24): `pulp/integer_SIMD_fix` = `PULP_18_HEAD`; merge base with `upstream/release/19.x` is `93248729`; `fork_anatomy.py map` gives the same 124 files as `data/fork-files-18.tsv`; `port/18` restacked into 11 cluster commits, tree identical to head. Baseline (2026-09-24): no known failures, so `data/known-failures.txt` is not created. Every test in `LIT_PATHS` is PASS (none are XFAIL; all REQUIRES are satisfied). Reference toolchain installed at `toolchains/ref-18`; `-march=rv32imc_xpulpv2` accepted. Harness fix: `lit.sh` previously ran 0 RISCVISAInfo unit tests (wrong binary at 18, and a `RISCVISAInfo*` gtest filter that matches no suite at any version) and still reported green; it now picks the binary by the test file's location, builds the filter from the file's suite names, and fails if the unit run fails or runs 0 tests. Step bases: 19 `llvmorg-19.1.7`, 20 `llvmorg-20.1.8`, 21 `llvmorg-21.1.8`, 22 `llvmorg-22.1.7` (pinned; latest is 22.1.8), 23 `llvmorg-23.1.2`.

Previous host (harness authoring): Amazon Linux 2, gcc 7.3.1, builds in `pulp-llvm-builder:1`.

## Escalations

| Step | Task | Question | Evidence | Status |
|---|---|---|---|---|
| 19 | conflict-registration | The fork's 21 smallfloat extensions (`xfalthalf` ... `xfexpauxvecaltquarter`) are plain `SubtargetFeature`s in the generated `RISCVInstrInfoXsmallfloatGen.td`; at 19 the ISAInfo table is generated only from `RISCVExtension` records, so `-march` would reject them. Hand-edit the 21 definitions to `RISCVExtension<..., 0, 1, ...>` (generator noah95/riscv-opcodes is not in the fork), or regenerate? | `notes/19/conflict-registration.md`; upstream `80628ee0d555` | Resolved: approved E004 landed through T005 dependency gate; 21 registrations restored and 83/83 required unit tests PASS |
| 19 | conflict-codegen-core (1) | At 19 `RISCVCC::getBrCond(CC, Imm)` returns `CV_BEQIMM`/`CV_BNEIMM` for immediate conditions, so a PULP `P_BEQIMM`/`P_BNEIMM` re-inserted after branch analysis would come back as the CORE-V opcode (needs XCVbi, different encoding). Route PULP immediates to `P_B*IMM` when Xpulpv2 is on? | `notes/19/conflict-codegen-core.md` | Open: to be checked in build/test phase (worker task if a test or the fork's lit shows it) |
| 19 | conflict-codegen-core (2) | Order when xpulpv and xcvmem are both enabled: ISel tries PULP post-increment before XCVmem, but `getPostIndexedAddressParts` returns early for XCVmem first | `notes/19/conflict-codegen-core.md` | Open, low impact (only both extensions together) |
| 19 | conflict-codegen-core (3) | Calling convention: upstream's `RVVDispatcher` counts PULP v4i8/v2i16 args it never assigns, so with V and Xpulpv2 both enabled later RVV args may get the wrong register; `CC_RISCV_FastCC` has no PULP case (gap already at 18) | `notes/19/conflict-codegen-core.md` | Open, low impact (V + Xpulpv2 together) |
| 19 | conflict-passes | The five fork pre-RA passes (PULPExpandPseudo, RISCVExpandSDMA, RISCVExpandSSR, SNITCHFrepLoops, PULPHardwareLoops) now run before `RISCVInsertVSETVLI`/`RISCVDeadRegisterDefinitions` (upstream moved those after vector RA: `52187b9f2e7e`, `0ebe48f068c0`, `1a58e88690c1`, `675e7bd1b94f`); no slot keeps the old order without moving fork passes past RA | `notes/19/conflict-passes.md` | Resolved for tested paths: all pipeline/hwloop/FREP/SSR/SDMA lit PASS; approved T001 only updates dead CSR destination/alias checks, production pipeline retained |
| 19 | conflict-mc | `isUImm6Lsb0()` and `def uimm6_lsb0` now defined twice: fork's (constant or bare symbol, `RISCVInstrInfoXpulp.td:31`) vs upstream's XWchc one (`3c5f929ad093`, constants only, `RISCVInstrInfoXwch.td:62`); different operands sharing a name | `notes/19/conflict-mc.md` | Resolved by approved and landed E003; notes/19/E003.md; clean build and PULP MC parser test PASS |
| 19 | conflict-clang-builtins | 64 fork vector builtins use `_Vector<N,T>` (GCC vector_size) which the 19.1.7 builtins TableGen emitter cannot parse; support arrived in `508263824f4e` (in 20). (a) backport its ~3-line parser change into `clang/utils/TableGen/ClangBuiltinsEmitter.cpp` with `Upstream-File-Edit:` (disappears at 20), or (b) `_ExtVector` (changes builtin types) | `notes/19/conflict-clang-builtins.md` | Resolved by approved and landed E002 backport; remove naturally at 20; diagnostic drift tracked separately as T004 |
| 19 | T002 | Allow mechanical MC CHECK-DISASM byte-format migration, or supply LLVM MC updater (absent at 19)? | notes/19/T002.md; logs/19-T002.equivalence.json; b27f86b40b20; 18 exact encoding-preserving replacements | Resolved: owner-approved scope implemented, independently reviewed and LANDED; full integration lit/unit green |
| 19 | T004 | Allow 91 expected-error messages to follow upstream CodeGen diagnostics, retaining every builtin call and feature rejection? | notes/19/T004.md; notes/19/T004.diagnostic-proposal.json; 13b653ab1127 | Resolved: owner-approved scope implemented, independently reviewed and LANDED; full integration lit/unit green |
| 19 | T001 | Allow regeneration for six dead CSR destination changes and resulting csrsi/csrci aliases from upstream DeadRegisterDefinitions placement? | notes/19/T001.md; logs/19-T001.actual.s; logs/19-T001.no-dead.s; 52187b9f2e7e | Resolved: owner-approved scope implemented, independently reviewed and LANDED; full integration lit/unit green |
| 19 | T003 | Eight baseline tests moved upstream; preserve comparison through explicit proven identity mappings. | notes/19/T001.md; notes/19/T003.md; mapped destinations PASS | Resolved: H001 mapping support applied after independent review; audit confirms eight mapped destinations PASS, no dropped coverage |
| 19 | T005 | Allow 26 one-space padding updates in C++ extension-help expected string? E004 also required for 21 missing production rows. | notes/19/T005.md; notes/19/T005.proposed.patch; 207e45fb67ee | Resolved: owner-approved scope implemented, independently reviewed and LANDED; full integration lit/unit green |
| 20 | conflict-codegen-core (1) | PULP branch-immediate round trip may still reconstruct CORE-V opcodes. | notes/20/conflict-codegen-core.md; inherited19 question | Open; preserved behavior, check lit |
| 20 | conflict-codegen-core (2) | PULP versus XCVmem selection priority differs between selector and lowering when both enabled. | notes/20/conflict-codegen-core.md | Open; no new priority policy chosen |
| 20 | conflict-codegen-core (3) | RVVArgDispatcher removed upstream, but broad PULP vector-to-GPR rule and fastcc gap remain; validate packed ABI/mixed extensions. | notes/20/conflict-codegen-core.md; CC relocation093b8bfe6b64 | Open; preserve ABI, follow upstream RVV elsewhere |
| 20 | conflict-passes | Validate optional machine pipeliner and Zicfilp with PULP/FREP; no upstream equivalent establishes combined compatibility. | notes/20/conflict-passes.md; 2c782ab27187/e80d8e1b421b | Open; preserved all upstream/fork passes and stage order |
