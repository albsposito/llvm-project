# LLVM 19 port report

Status: **GREEN**, local tag `port-19-green` at `9b2edaf923ad`. Generated from task/result/review/integration artifacts and notes, 2026-09-25.

Base: `llvmorg-19.1.7`. Stack: `9b2edaf923ad46816535d7361e9daef79be0529c`. Tree: `a34d645fe7fb764d46df0849b645ca4d4417d3ae`. Autosquash retained the exact pre-squash tree and 11 cluster commits ([evidence](autosquash.json)).

## Validation

- Full integration build clean, latest landing [T004 gate](../../tasks/19/T004.integrate.json).
- Before final restack validation: 4531/4531 lit PASS, 56/56 fork lit PASS, 83/83 required unit PASS. [Last integration report](../../tasks/19/work_19_T004.lit_diff.json).
- Final restacked validation PASS: **4531/4531 lit, 56/56 fork lit, 83/83 required unit tests**. [Final report](lit-final/lit_diff.json). Test-dependency build also completed cleanly.
- [Fixup policy](policy.json): 16 commits, 0 FAIL, 8 WARN independently reviewed (temporary upstream-file backport and seven test-file updates).
- Downstream oracle did **not** run: ORACLE.md still reports design only; the lane runner is not built. Owner standing instruction permits lit-only release steps.
- Owner standing authorization permits continuing to 20 without a release-gate pause. This is not a claim of a new manual report review; nothing was pushed.

## Work and dispositions

Build-fix phase: 11 E-task records; 10 tasks landed 11 commits during build repair, while E004 was parked. Test-fix round 1: 5 T-task records; four fixes landed plus E004 dependency, while T003 and missing paths in T001 were resolved by validated upstream-identity mappings. The durable handoff records two build-fix rounds; retained primary build log is `logs/build-int-19-r1.log`, with per-task landing build logs under tasks/19. Test audit and each landing reran the suite; these were validation runs, not additional unchanged-failure fix rounds.

| Task | Final disposition | Worker commit count (includes dependencies) | Evidence |
|---|---|---:|---|
| E001 | LANDED | 1 | [result](../../tasks/19/E001.result.json), [note](../../notes/19/E001.md) |
| E002 | LANDED | 1 | [result](../../tasks/19/E002.result.json), [note](../../notes/19/E002.md) |
| E003 | LANDED | 2 | [result](../../tasks/19/E003.result.json), [note](../../notes/19/E003.md) |
| E004 | LANDED via T005 dependency chain (original standalone gate rejected) | 1 | [result](../../tasks/19/E004.result.json), [note](../../notes/19/E004.md) |
| E005 | LANDED | 1 | [result](../../tasks/19/E005.result.json), [note](../../notes/19/E005.md) |
| E006 | LANDED | 1 | [result](../../tasks/19/E006.result.json), [note](../../notes/19/E006.md) |
| E007 | LANDED | 1 | [result](../../tasks/19/E007.result.json), [note](../../notes/19/E007.md) |
| E008 | LANDED | 1 | [result](../../tasks/19/E008.result.json), [note](../../notes/19/E008.md) |
| E009 | LANDED | 1 | [result](../../tasks/19/E009.result.json), [note](../../notes/19/E009.md) |
| E010 | LANDED | 1 | [result](../../tasks/19/E010.result.json), [note](../../notes/19/E010.md) |
| E011 | LANDED | 1 | [result](../../tasks/19/E011.result.json), [note](../../notes/19/E011.md) |
| T001 | LANDED | 1 | [result](../../tasks/19/T001.result.json), [note](../../notes/19/T001.md) |
| T002 | LANDED | 1 | [result](../../tasks/19/T002.result.json), [note](../../notes/19/T002.md) |
| T003 | Resolved through reviewed H001 mappings | 0 | [result](../../tasks/19/T003.result.json), [note](../../notes/19/T003.md) |
| T004 | LANDED | 1 | [result](../../tasks/19/T004.result.json), [note](../../notes/19/T004.md) |
| T005 | LANDED | 2 | [result](../../tasks/19/T005.result.json), [note](../../notes/19/T005.md) |

E004 original standalone integration rejection remains preserved in its artifact; successful dependency integration is [recorded separately](../../tasks/19/E004.landing.json). T005 includes the exact E004 patch plus its own formatting-only commit. T005's first landing attempt hit a missing handoff baseline JSON; it was restored to the clean checkpoint, the baseline regenerated from saved build output, and the complete gate rerun successfully ([recovery](../../tasks/19/T005.integrate-attempt1.json)).

## Test identity and authorized adaptations

The unit test moved from `llvm/unittests/Support/RISCVISAInfoTest.cpp` to `llvm/unittests/TargetParser/RISCVISAInfoTest.cpp`; the fork manifest retains it at the new path ([record](fork-test-renames.md)). Eight upstream lit identities moved or were replaced; each is retained via an audited mapping requiring its candidate destination to PASS ([mapping with upstream hashes](baseline-renames.json)). No baseline test was dropped or suppressed.

Owner-approved scope and refinements: [authorization](../../notes/19/owner-test-exceptions.md), [independent proposal review](../../notes/19/test-policy-proposal-review.md). Final changes are 18 unchanged-bit MC encoding display fields; 91 builtin-specific missing-xpulpv diagnostic annotations; 25 padding spaces (the longest name was already correctly aligned); five existing CSR checks corresponding to six emitted dead-destination/alias changes. The FREP semantic classification is explicit and covered only by this narrow owner exception. All RUN lines, test inputs, assertions and remaining checks are preserved.

Harness H001/H002 adds explicit rename accounting and unit-failure evidence/strict integration checks. Combined final patch independently approved; 22 harness tests PASS. [Review](../../tasks/19/H001-H002.review.json), [application record](../../tasks/19/H001-H002.integrate.json). H002's initial documentation-only rejection was resolved before application. Harness modifications remain working-tree changes alongside pre-existing owner harness edits; they are not LLVM cluster commits.

## Remaining escalations and limits

Three codegen-core questions remain in PROGRESS.md: PULP immediate branch re-insertion versus CORE-V opcode selection; priority when PULP and XCVmem coexist; argument-register accounting when PULP packed vectors and RVV coexist. Current lit did not expose failures in those cases; no guessed code changes were made. D1 (route at 22) and D2 (downstream oracle) remain owner decisions. Continue the already selected route 1 unless directed otherwise.

## Cluster commits

```text
43da10e5e761 [pulp] registration: extensions, features, processors, CSRs
1121be252fb3 [pulp] insn-tablegen: Xpulp/Xsmallfloat/Xssr/Xdma/Xfrep instructions and sched models
79b5ff2997eb [pulp] intrinsics: IR intrinsics and SelectionDAG nodes
24a15b1dc253 [pulp] codegen-core: lowering, ISel, instr/register info, TTI
647fe517f583 [pulp] passes: hardware loops, FREP, SSR/SDMA expansion, pseudo expansion
c4a67fb39292 [pulp] mc: asm parser, disassembler, encoder, fixups, relocations, lld
413f087fbb1b [pulp] clang-builtins: RISC-V builtins and their Sema checks
8bc56ac8a0f8 [pulp] clang-frep-pragma: #pragma frep parsing, attribute, codegen
4cdba2865c14 [pulp] clang-driver: target macros and driver flags
1aa5cd982ae0 [pulp] tests: fork-authored lit tests and pipeline expectations
9b2edaf923ad [pulp] docs: fork README
```

## Change and evidence notes

- [E001.md](../../notes/19/E001.md)
- [E002.md](../../notes/19/E002.md)
- [E003.md](../../notes/19/E003.md)
- [E004.md](../../notes/19/E004.md)
- [E005.md](../../notes/19/E005.md)
- [E006.md](../../notes/19/E006.md)
- [E007.md](../../notes/19/E007.md)
- [E008.md](../../notes/19/E008.md)
- [E009.md](../../notes/19/E009.md)
- [E010.md](../../notes/19/E010.md)
- [E011.md](../../notes/19/E011.md)
- [H001.md](../../notes/19/H001.md)
- [H002.md](../../notes/19/H002.md)
- [T001.md](../../notes/19/T001.md)
- [T001.regen.md](../../notes/19/T001.regen.md)
- [T002.md](../../notes/19/T002.md)
- [T002.regen.md](../../notes/19/T002.regen.md)
- [T003.md](../../notes/19/T003.md)
- [T004.md](../../notes/19/T004.md)
- [T004.regen.md](../../notes/19/T004.regen.md)
- [T005.md](../../notes/19/T005.md)
- [T005.regen.md](../../notes/19/T005.regen.md)
- [conflict-clang-builtins.md](../../notes/19/conflict-clang-builtins.md)
- [conflict-clang-driver.md](../../notes/19/conflict-clang-driver.md)
- [conflict-clang-frep-pragma.md](../../notes/19/conflict-clang-frep-pragma.md)
- [conflict-codegen-core.md](../../notes/19/conflict-codegen-core.md)
- [conflict-insn-tablegen.md](../../notes/19/conflict-insn-tablegen.md)
- [conflict-mc.md](../../notes/19/conflict-mc.md)
- [conflict-passes.md](../../notes/19/conflict-passes.md)
- [conflict-registration.md](../../notes/19/conflict-registration.md)
- [conflict-tests.md](../../notes/19/conflict-tests.md)
- [owner-test-exceptions.md](../../notes/19/owner-test-exceptions.md)
- [test-policy-proposal-review.md](../../notes/19/test-policy-proposal-review.md)

Replay configuration before step20 test relocation: [config](checkpoint-config.env), [fork manifest](checkpoint-fork-tests.txt). Current global harness paths may target a later step.
