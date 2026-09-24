# Progress

Durable state of the port. The conductor updates this file at the end of every SOP step; after a context reset it is read before anything else.

Current phase: **Phase 0 not started** (harness built and tested 2026-09-24; no clone yet)

## Steps

| Step | Base tag | Status | Stack tip | Rounds (build / test) | Landed | Escalated | Green tag | Owner approved |
|---|---|---|---|---|---|---|---|---|
| 18 baseline | merge base `e6c32898` | not started | | | | | | |
| 19 | | not started | | | | | | |
| 20 | | not started | | | | | | |
| 21 | | not started | | | | | | |
| 22 | `llvmorg-22.1.7` (pinned) | not started | | | | | | |
| 23 | | not started | | | | | | |

## Decisions

| ID | Decision | Status |
|---|---|---|
| D0 | Start with route 1 (release-by-release rebase of `integer_SIMD_fix`); routes 1 and 2 are identical until 22 | Decided 2026-09-24 |
| D1 | At the 22 checkpoint: continue on own lineage to 23 (route 1), or move the codegen layers onto `llvmorg-22.1.7-pulp` (route 2) | Open, due at 22. Inputs: Luca Colagrande's plans, which extension families matter at 23, whether `riscv-opcodes` has hardware-loop and post-increment encodings |
| D2 | Oracle lane runner: build the Xpulpv2 lane before step 19 finishes, or run steps on lit only until it exists | Open |

## Owner actions

- [ ] Fork `pulp-platform/llvm-project` under your personal GitHub account, then run Phase 0 with its URL
- [ ] Message Luca Colagrande about the codegen layers and the 22 branch before step 22 at the latest
- [ ] Decide D2
- [ ] Review each step report and approve (the only human check in the loop)

## Host

32 cores, 123 GB RAM, ~700 GB free on `/local` (2026-09-24). Host gcc 7.3.1 is too old for LLVM, so builds run in `pulp-llvm-builder:1` (Ubuntu 24.04, clang 18.1.3, ninja 1.11.1, ccache 4.9.1, cmake 3.28.3, verified working).

## Escalations

| Step | Task | Question | Evidence | Status |
|---|---|---|---|---|
