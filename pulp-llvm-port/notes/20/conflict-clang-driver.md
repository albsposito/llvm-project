# 20/conflict-clang-driver: preserve PULP multilib with upstream diagnostics

## What upstream changed

Conflict inventory: `clang/lib/Driver/ToolChains/BareMetal.cpp` — both modified; the other four driver-cluster files merged automatically. Upstream commit `26bf0b4ae7df7f5350f71afd40a57cdf8f98c588` “[clang][Driver] Add a custom error option in multilib.yaml. (#105684)” passes the driver to multilib selection so it can report custom errors. Evidence came from range-limited `git log -G 'select\(D, Flags' llvmorg-19.1.7..llvmorg-20.1.8` and the commit diff.

## Why this is equivalent

Kept upstream's `select(D, Flags, Result.SelectedMultilibs)` call and all upstream multilib entries. Added the fork's existing `Imfcxpulpv2` entry alongside them, preserving its directory, architecture and ABI flags. The four automatically merged files retain fork target macros and driver flags. No design decision, feature deletion or relocation was needed. No test files were edited and no build was run.

## What breaks if this is wrong

Losing the fork entry changes bare-metal PULP library lookup; losing the driver argument fails compilation or prevents upstream multilib diagnostics. Validation: whitespace/conflict-marker checks before continuing the pick. Runtime selection remains for the step build and tests. `git diff --check` and marker checks for the resolution passed; the broader staged check reported inherited trailing whitespace at `clang/lib/Basic/Targets/RISCV.h:30`, left outside this conflict fix. Continued once, creating `ae2ab5d81658`; stopped at the next tests-cluster conflicts (`target-invalid-cpu-note.c`, `O0-pipeline.ll`, `O3-pipeline.ll`).

## Upstream reference

- Commit: `26bf0b4ae7df7f5350f71afd40a57cdf8f98c588` [clang][Driver] Add a custom error option in multilib.yaml. (#105684)
- Reference code: `clang/lib/Driver/ToolChains/BareMetal.cpp:95` at `llvmorg-20.1.8`; same RISC-V multilib selection call, no CORE-V relocation involved.
- Release notes: not mentioned.
