# LLVM 20 port report

Status: **GREEN**, local tag `port-20-green` at `b6cd96bd3726`. Generated 2026-09-27 from the task, result, review and landing files under `tasks/20/` and `notes/20/`. Nothing was pushed.

Base: `llvmorg-20.1.8`. Stack: `b6cd96bd37263d1ab670bf7b54fd64253fc87619`. Tree: `7ae6e8dd20854809bd891b6e0d8cb62d0c2b1a58`. Autosquash kept the exact pre-squash tree (pre-squash head in `steps/20/pre-autosquash-head`) and exactly 11 cluster commits:

```
b6cd96bd3726 [pulp] docs: fork README
8d7024c1cfff [pulp] tests: fork-authored lit tests and pipeline expectations
10daba4697e0 [pulp] clang-driver: target macros and driver flags
8de6c86e629e [pulp] clang-frep-pragma: #pragma frep parsing, attribute, codegen
f4abfd2cad01 [pulp] clang-builtins: RISC-V builtins and their Sema checks
9aad6c26defc [pulp] mc: asm parser, disassembler, encoder, fixups, relocations, lld
107c477dfbda [pulp] passes: hardware loops, FREP, SSR/SDMA expansion, pseudo expansion
4a3d6414933d [pulp] codegen-core: lowering, ISel, instr/register info, TTI
0d2bfdd94ae8 [pulp] intrinsics: IR intrinsics and SelectionDAG nodes
49545edf875e [pulp] insn-tablegen: Xpulp/Xsmallfloat/Xssr/Xdma/Xfrep instructions and sched models
324298c2579c [pulp] registration: extensions, features, processors, CSRs
```

## Validation

- Clean build of `clang lld llc llvm-mc opt llvm-objdump` after the final restack (`logs/build-int-20-final.log`).
- Final lit ([report](lit-final/lit_diff.json)): **green**, 4720 PASS, 1 FAIL (the one owner-approved known failure below), 0 problems; RISCVISAInfo unit tests 84/84 PASS; every fork test in `data/fork-tests.txt` ran and passed.
- Baseline: `steps/19/lit-final/lit.json` (port-19-green), with the reviewed rename mapping `steps/20/baseline-renames.json` (upstream split `clang/test/Misc/target-invalid-cpu-note.c` into 16 per-target files, H003).
- 125 baseline tests no longer exist because upstream deleted or moved them between 19.1.7 and 20.1.8; they are listed under `upstream_removed` in the final report, not counted as regressions (harness change H004, three review rounds). None is a fork test; the reviewer confirmed an upstream delete/rename commit for every one.
- [Policy check](policy.json) over all step fixups: 11 commits, 0 FAIL, 2 WARN (the two owner-approved test edits, each independently reviewed with a regen report).
- Downstream oracle did **not** run (not built). The owner has since supplied the GAP9 SDK and GAP9 GCC toolchain as the benchmark corpus; a benchmark sweep follows this report.

## Work and dispositions

Build-fix: round 1 (Codex, pre-resume) plus round 2; test-fix: 1 round. A throwaway probe build (never landed, `steps/20/probe-hack.patch`) exposed the C++ errors hidden behind a TableGen error, saving one build round.

| Task | Worker status | Review | Disposition | Evidence |
|---|---|---|---|---|
| E001 | done | APPROVE | LANDED | [task](../../tasks/20/E001.md), [result](../../tasks/20/E001.result.json), [review](../../tasks/20/E001.review.json), [landing](../../tasks/20/E001.integrate.json), [note](../../notes/20/E001.md) |
| E002 | — | — | coalesced into E001 (same root cause) | [task](../../tasks/20/E002.md) |
| E003 | — | — | coalesced into E001 (same root cause) | [task](../../tasks/20/E003.md) |
| E004 | done | APPROVE | LANDED | [task](../../tasks/20/E004.md), [result](../../tasks/20/E004.result.json), [review](../../tasks/20/E004.review.json), [landing](../../tasks/20/E004.integrate.json), [note](../../notes/20/E004.md) |
| E005 | done | APPROVE | LANDED | [task](../../tasks/20/E005.md), [result](../../tasks/20/E005.result.json), [review](../../tasks/20/E005.review.json), [landing](../../tasks/20/E005.integrate.json), [note](../../notes/20/E005.md) |
| E006 | done | APPROVE | LANDED | [task](../../tasks/20/E006.md), [result](../../tasks/20/E006.result.json), [review](../../tasks/20/E006.review.json), [landing](../../tasks/20/E006.integrate.json), [note](../../notes/20/E006.md) |
| E007 | done | APPROVE | LANDED | [task](../../tasks/20/E007.md), [result](../../tasks/20/E007.result.json), [review](../../tasks/20/E007.review.json), [landing](../../tasks/20/E007.integrate.json), [note](../../notes/20/E007.md) |
| H003 | ready_for_review | APPROVE | harness change, applied (reviewed) | [task](../../tasks/20/H003.md), [result](../../tasks/20/H003.result.json), [review](../../tasks/20/H003.review.json), [note](../../notes/20/H003.md) |
| H004 | — | APPROVE | harness change, applied (reviewed) | [task](../../tasks/20/H004.md), [review](../../tasks/20/H004.review.json) |
| T001 | escalated | — | escalated → owner approved test edit, landed as T006 | [task](../../tasks/20/T001.md), [result](../../tasks/20/T001.result.json) |
| T002 | escalated | — | owner: known failure (notes/20/owner-test-exceptions.md) | [task](../../tasks/20/T002.md), [result](../../tasks/20/T002.result.json) |
| T003 | escalated | APPROVE | code approved; landed together with T008 | [task](../../tasks/20/T003.md), [result](../../tasks/20/T003.result.json), [review](../../tasks/20/T003.review.json), [note](../../notes/20/T003.md) |
| T004 | escalated | — | escalated → owner decision D3, landed as T007 | [task](../../tasks/20/T004.md), [result](../../tasks/20/T004.result.json) |
| T005 | escalated | — | escalated → owner decision D3, landed as T007 | [task](../../tasks/20/T005.md), [result](../../tasks/20/T005.result.json) |
| T006 | done | APPROVE | LANDED | [task](../../tasks/20/T006.md), [result](../../tasks/20/T006.result.json), [review](../../tasks/20/T006.review.json), [landing](../../tasks/20/T006.integrate.json), [note](../../notes/20/T006.md) |
| T007 | done | APPROVE | LANDED | [task](../../tasks/20/T007.md), [result](../../tasks/20/T007.result.json), [review](../../tasks/20/T007.review.json), [landing](../../tasks/20/T007.integrate.json), [note](../../notes/20/T007.md) |
| T008 | done | APPROVE | LANDED | [task](../../tasks/20/T008.md), [result](../../tasks/20/T008.result.json), [review](../../tasks/20/T008.review.json), [landing](../../tasks/20/T008.integrate.json), [note](../../notes/20/T008.md) |

## Owner decisions taken during this step (2026-09-27)

- **T001 / T006**: one expected-diagnostic CHECK line in fork test `rv32xmempool-invalid.s` updated to upstream's new CSR wording (`107f3efdbede`); fork behaviour unchanged. `notes/20/owner-test-exceptions.md`.
- **T002**: upstream test `rvv/vsetvli-insert-zve64f.mir` added to `data/known-failures.txt`: the fork's extra register classes shift register-class IDs, so a hardcoded inline-asm flag prints a different class name in a comment; generated code identical.
- **D3 / T007**: fork classes `PulpV2`/`PulpV4` renamed `GPRAV2`/`GPRAV4` so TableGen again treats them and `GPR` as mutual subclasses (lost after upstream `bc91f3cdd57c`); a name-order bridge, removed by the planned step-23 redesign.
- **T003 / T008**: FREP miscompile (upstream `9122c5235ec8` made the pre-RA scheduler bidirectional and it hoisted loop-body instructions above `frep.o`, so the body was not repeated) fixed by making `FREP_O`/`FREP_I` scheduling boundaries; one CHECK line added to fork test `freploop-nested.ll` for a moved assembler comment.

## Findings to review (open items, see PROGRESS.md escalations)

- FREP body integrity is not guaranteed by the boundary fix (pre-existing since 18/19).
- `xpulp-hwloop.ll` with `-verify-machineinstrs` reports verifier errors after the hardware-loop fixup pass (pre-existing at 19).
- No lit test pins the Xpulpv2 post-increment preference in `getPreferredAddressingMode` (merged with upstream's XCVmem version in E007).
- Pre-flagged silent-break risks for steps 21 and 23 from the verified leads (`steps/21/leads.md`, `steps/23/leads.md`).

## Harness changes during this step

H003 (reviewed baseline renames), H004 (upstream-removed rule, `--worktree`/`--upstream-tag`, hardened after two review rejections), `integrate.py` input checks and empty clusters file on a clean build, `AGENT_RULES.md` rule 13a (no `git stash`), throughput settings (`MAX_WORKERS=8`, `JOBS_INTEGRATION=32`, ninja load cap, 6 link jobs).

## Change notes

- `notes/20/E001.md`
- `notes/20/E004.md`
- `notes/20/E005.md`
- `notes/20/E006.md`
- `notes/20/E007.md`
- `notes/20/H003-review.md`
- `notes/20/H003.md`
- `notes/20/T003.md`
- `notes/20/T006-regen.md`
- `notes/20/T006.md`
- `notes/20/T007.md`
- `notes/20/T008-regen.md`
- `notes/20/T008.md`
- `notes/20/conflict-clang-builtins.md`
- `notes/20/conflict-clang-driver.md`
- `notes/20/conflict-clang-frep-pragma.md`
- `notes/20/conflict-codegen-core.md`
- `notes/20/conflict-insn-tablegen.md`
- `notes/20/conflict-mc.md`
- `notes/20/conflict-passes.md`
- `notes/20/conflict-registration.md`
- `notes/20/conflict-tests.md`
- `notes/20/owner-test-exceptions.md`
- `notes/20/ownership-relocations.md`
