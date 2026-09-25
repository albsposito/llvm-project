# 20/conflict-passes: preserve both pre-register-allocation pipelines

## What upstream changed

Conflict inventory: `llvm/lib/Target/RISCV/RISCVTargetMachine.cpp` — both modified; the only conflicted path.
`e80d8e1b421b` [RISCV] Insert simple landing pad before indirect jumps for Zicfilp. (#91860) adds landing-pad setup at the same insertion point as the fork passes. `2c782ab27187` [RISCV] Add software pipeliner support (#117546) adds an opt-in machine pipeliner at the end of this hook. `0cbccb13d675` [RISCV] Remove support for pre-RA vsetvli insertion (#110796) removes the former VSETVLI placement logic. `bb3f5e1fed7c` Overhaul the TargetMachine and LLVMTargetMachine Classes (#111234) changes the target-machine class API; its upstream adaptation is retained.

## Why this is equivalent

Retained all upstream code and inserted the complete fork sequence immediately after landing-pad setup and before the upstream optional pipeliner. Fork relative ordering is unchanged: PULP pseudo expansion, SDMA expansion, SSR expansion, SNITCH FREP, PULP hardware loops. All fork registrations and the PULP hardware-loop fixup after ordinary pseudo expansion remain. No unconflicted API/build errors were repaired; no test was edited. This preserves the fork's existing pre-RA stage and upstream relative ordering, without asserting compatibility of previously nonexistent feature combinations.

ESCALATE: LLVM 20 adds the optional machine pipeliner after this stage and Zicfilp landing-pad setup before the fork sequence. Upstream has no equivalent PULP hardware-loop/FREP pass pipeline establishing compatibility with those combinations. Validate PULP/FREP plus `-riscv-enable-pipeliner` and Zicfilp before declaring semantic equivalence; no feature has been disabled, deleted, or reordered to avoid the issue.

## What breaks if this is wrong

Combined software-pipelining and PULP/FREP loops could produce invalid loop control or unexpected instruction changes. Zicfilp combinations could miss required indirect-branch setup if later fork expansion creates indirect transfers. Conflict resolution is checked only with diff/marker checks, not a build or semantic execution test, per resolver SOP.

## Upstream reference

- `e80d8e1b421b` [RISCV] Insert simple landing pad before indirect jumps for Zicfilp. (#91860).
- `2c782ab27187` [RISCV] Add software pipeliner support (#117546).
- `0cbccb13d675` [RISCV] Remove support for pre-RA vsetvli insertion (#110796).
- `bb3f5e1fed7c` Overhaul the TargetMachine and LLVMTargetMachine Classes (#111234).
- Pipeline reference: `llvm/lib/Target/RISCV/RISCVTargetMachine.cpp:603` at llvmorg-20.1.8; landing-pad implementation `llvm/lib/Target/RISCV/RISCVLandingPadSetup.cpp:47`.
- CORE-V comparison: `llvm/lib/Target/RISCV/RISCVInstrInfoXCV.td:687` implements XCVmem selection patterns, not an equivalent hardware-loop/FREP pipeline; no relocation into this file was warranted.
- Release notes: history evidence from the verified step leads; no release-note claim required.

Result: diff --check clean and conflict-marker search empty before staging. Continued once, producing `c4d6c40d9f9d`; stopped at next pick `c4a67fb39292` (mc), with four conflicted paths. No build run.
