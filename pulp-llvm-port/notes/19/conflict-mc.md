# Step 19 conflict: mc

Pick: `21396cb97d59` "[pulp] mc: asm parser, disassembler, encoder, fixups, relocations, lld"
Worktree: `wt/int-19` (branch `port/19`), prev base `e6c3289804a6` (fork's LLVM 18 merge base), new base `llvmorg-19.1.7`.
Auto-merged (no conflict): `lld/ELF/Arch/RISCV.cpp`, `llvm/include/llvm/BinaryFormat/ELFRelocs/RISCV.def`, `RISCVAsmBackend.cpp`, `RISCVBaseInfo.h`, `RISCVELFObjectWriter.cpp`, `RISCVFixupKinds.h`, `RISCVMCCodeEmitter.cpp`; in the two conflicted files, every fork hunk other than the ones below also auto-merged (asm parser: `isUImm6Lsb0`, `isUImm12M1`, `isUImm13Lsb0`, the `!` post-increment token in `parseMemOpBaseReg`, the reg-then-`(` memory operand path in `parseOperand`; disassembler: `DecodePulpV2RegisterClass`, `DecodePulpV4RegisterClass`, `decodeUImmMinus1Operand<N>`).

## Paths

| Path | Conflict type | Upstream change | Resolution |
|---|---|---|---|
| `llvm/lib/Target/RISCV/AsmParser/RISCVAsmParser.cpp` | both modified (adjacent lines in the `isUImmN()` list) | `2a086dce691e` "[RISCV][MC] Add support for hardcode encoding of .insn directive (#98030)" added `isUImm16()` (and `isUImm32()`) right where the fork added `isUImm12()` | Kept upstream's `isUImm16()` / `isUImm32()`; inserted the fork's `isUImm12()` in numeric order (after `isUImm8()`, before `isUImm16()`). `isUImm12` does not exist upstream at 19, so no duplicate. |
| `llvm/lib/Target/RISCV/Disassembler/RISCVDisassembler.cpp` | both modified (the whole 32-bit decode block) | `5569c219d35c` "[RISCV] Split RISCVDisassembler::getInstruction into a 16-bit and 32-bit version. (#90254)" moved the 32-bit table list into the new `getInstruction32()` (de-indented, `uint32_t Insn` local); upstream also added the SiFive `XSiFivecdiscarddlone` / `XSiFivecflushdlone` / `XSfcease` tables | Kept upstream's `getInstruction32()` verbatim and dropped the stale 18-era copy of the block. Re-inserted the fork's one line `TRY_TO_DECODE_FEATURE(RISCV::FeaturePULPExtV2, DecoderTableRV32Xpulp32, "RV32Xpulp custom opcode table (PULP extensions)")` in `getInstruction32()` at the same position as at 18: right after the last CORE-V table (`XCVbi`) and before the generic `DecoderTable32` fallback, i.e. the same way upstream tries its vendor tables (reference: the `FeatureVendorXCVbi` / `DecoderTableXCVbi32` line in `getInstruction32()` of `RISCVDisassembler.cpp` at `llvmorg-19.1.7`). |

`git diff HEAD` for the two files now shows only fork additions (no upstream line removed or changed).

## Semantic collision found in the auto-merged part (not a textual conflict)

- ESCALATE: `isUImm6Lsb0()` is now defined twice in `RISCVOperand` (`RISCVAsmParser.cpp`, around lines 785 and 851): the fork's version (accepts a constant `isShiftedUInt<5,1>` OR a bare symbol reference via `classifySymbolRef`) and upstream's new one from `3c5f929ad093` "[RISCV] Add QingKe "XW" compressed opcode extension (#97925)" (constant only). This will not compile. Matching collision in TableGen: `def uimm6_lsb0` exists both in the fork's `RISCVInstrInfoXpulp.td:31` (encoder `getImmOpValueAsr1`, decoder `decodeUImmOperand<13>`, symbol refs allowed — a PC-relative-style loop offset) and upstream's `RISCVInstrInfoXwch.td:62` (encoder `getImmOpValue`, decoder `decodeUImmOperand<6>`, constant only). They are different operands sharing a name, so the fix is a design decision (likely rename the fork's operand and its asm operand class, e.g. a PULP-specific name, instead of merging semantics, since merging would change XWchc behaviour). Left both definitions untouched; this belongs to the build-fix phase (owner cluster of the `.td` is insn-tablegen, the C++ predicate is mc).

## Build-phase leads (not checked, by design)

- `decodeUImmOperand` now takes `uint32_t Imm` at 19; the fork's `decodeUImmMinus1Operand<N>` takes `uint64_t Imm` and forwards `Imm + 1` — probably fine but check for template/decoder-signature mismatches.
- `git diff --cached --check` reports trailing whitespace only in fork lines carried verbatim (`RISCVAsmBackend.cpp:95`, `RISCVELFObjectWriter.cpp:103`); not touched.

Markers check: no `<<<<<<<` / `|||||||` / `=======` / `>>>>>>>` lines in the two resolved paths.
