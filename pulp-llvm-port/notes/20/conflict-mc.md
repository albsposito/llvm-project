# Step 20 MC conflict resolution

## Scope
Paused pick c4a67fb39292, `[pulp] mc: asm parser, disassembler, encoder, fixups, relocations, lld`, from llvmorg-19.1.7 onto llvmorg-20.1.8. Four paths were both modified. No tests edited or builds run.

## Upstream evidence and resolution
- `lld/ELF/Arch/RISCV.cpp`: 04996a28b763, `[ELF] Rename target-specific RelExpr enumerators`, renamed R_RISCV_LEB128 to RE_RISCV_LEB128. Retained the upstream name and both PULPV2 loop relocation cases returning R_NONE.
- `llvm/include/llvm/BinaryFormat/ELFRelocs/RISCV.def`: fea7b65f2363, `[RISCV] Add Vendor Reloc and Fallback Names (#116974)`, adds vendor relocation 191 and custom values 192–255. Retained all entries plus the fork's existing 66–69 assignments; there is no numeric overlap. 525f5262af81, `[RISCV] Support Parsing Nonstandard Relocations (#119909)`, introduces aliases in RISCV_nonstandard.def. Its comment explicitly reserves RISCV.def for one-to-one enum mapping. The fork's four unique enum values therefore remain in RISCV.def, preserving object writer references and ABI without inventing a vendor discriminator or changing numbering. The upstream backend nonstandard-name lookup remains intact at RISCVAsmBackend.cpp:44–46.
- `llvm/lib/Target/RISCV/AsmParser/RISCVAsmParser.cpp`: 6881c6d2a6ef, `[RISCV] Add Qualcomm uC Xqcia (Arithmetic) extension (#118113)`, and 171d3edd0507, `[RISCV] Add Qualcomm uC Xqciint (Interrupts) extension (#122256)`, add immediate predicates. Retained upstream UImm10/UImm11 and fork UImm12 with all existing predicates.
- `llvm/lib/Target/RISCV/Disassembler/RISCVDisassembler.cpp`: bde3d4a62e71, `[RISCV] Only allow 5 bit shift amounts in disassembler for RV32. (#115432)`, adds decodeUImmLog2XLenOperand; retained it including assertion/failure checks alongside all three PULP helpers. Qualcomm additions beginning c4645ffedaca, `[RISCV] Add Qualcomm uC Xqcicsr (CSR) extension (#117169)`, and through 171d3edd0507 add vendor decoder tables; all remain in upstream order. PULP table stays the final feature-gated vendor attempt before the generic decoder, matching prior fork placement. Closest CORE-V reference is FeatureVendorXCVbi dispatch at RISCVDisassembler.cpp:721. No instruction encodings or feature predicates were changed.

## Validation
`git diff --check` passed; explicit conflict-marker scan across all four paths found none. This checks resolution integrity only, not compilation or instruction behavior. No conflicting numeric relocation or instruction encoding policy was encountered in these textual conflicts.

## Result
Resolved four paths by preserving upstream implementations and adding fork functionality. No behavior-removal decision needed. Continue once and leave the next paused cluster for its owner.

MC committed as `22d0eb292f20`; sequencer paused next at clang-builtins pick `413f087fbb1b`, conflict `clang/include/clang/Basic/BuiltinsRISCV.td`. No further cluster changes made.
