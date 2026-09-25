# Conflict: insn-tablegen (step 19)

Pick: `0776383365d5` "[pulp] insn-tablegen: Xpulp/Xsmallfloat/Xssr/Xdma/Xfrep instructions and sched models", applied onto `llvmorg-19.1.7` (stack from `port/18`, base `e6c3289804a6`), in `wt/int-19` on top of `eeb705def7b9` (registration).

One conflicted path. The eight new files (`RISCVInstrInfoX{dma,frep,pulp,smallfloat,smallfloatGen,ssr}.td`, `RISCVSched{Mempool,Snitch}.td`) were added cleanly.

## Paths

| Path | Conflict type | Upstream change | Resolution |
|---|---|---|---|
| `llvm/lib/Target/RISCV/RISCVInstrInfo.td` | both modified (vendor-extension include list) | `3c5f929ad093` "[RISCV] Add QingKe "XW" compressed opcode extension (#97925)" added `include "RISCVInstrInfoXwch.td"` right after `RISCVInstrInfoXCV.td`, the line the fork's hunk was anchored to. (Upstream also inserted `RISCVInstrInfoSFB.td` above `XCV`; that part merged cleanly.) | Kept upstream's `Xwch` include, then re-added the fork's five includes after it in their original order: `Xfrep`, `Xdma`, `Xssr`, `Xsmallfloat`, `Xpulp`. The fork's other two hunks in this file (the `uimm12` and `uimm12m1` operand defs) merged cleanly. I checked that 19.1.7 defines neither name (`OPERAND_UIMM12` already exists in `RISCVBaseInfo.h` upstream, as it did at 18), so they are not duplicates. |

## Checks

- `git diff --check`: clean. No `<<<<<<<` / `=======` / `>>>>>>>` left in the resolved path.
- `git diff --cached --check` reports trailing whitespace in `RISCVInstrInfoXssr.td` and `RISCVSchedMempool.td`, and a blank line at EOF in `RISCVInstrInfoXsmallfloatGen.td`. These come from the fork's own new files, carried over unchanged (not conflict leftovers), so I did not touch them.

## Not done here, by design

- The smallfloat `SubtargetFeature` -> `RISCVExtension` conversion in `RISCVInstrInfoXsmallfloatGen.td` (ESCALATE in `notes/19/conflict-registration.md`) is still open. It is a build-phase task and was explicitly out of scope for this conflict resolution.
- No TableGen/build attempted (per SOP); base-class drift in the new `.td` files will surface in the build phase.
