# LLVM 20 verified leads

Recon only, 2026-09-24. Target `llvmorg-20.1.8`; evidence is local upstream history in `llvmorg-19.1.7..llvmorg-20.1.8` and `git show llvmorg-20.1.8:{llvm/docs/ReleaseNotes.md,clang/docs/ReleaseNotes.rst}`. No step-20 source or integration worktree changed. “Verified” identifies an upstream change, not a demonstrated fork failure. Release notes are not comprehensive; history-only leads are identified below.

## Required leads

| Lead | Result | Upstream evidence and effect |
|---|---|---|
| Intrinsic::getDeclaration renamed | verified, with compatibility caveat | `fa789dffb1e1` “Rename Intrinsic::getDeclaration to getOrInsertDeclaration”; `b9f08676abcf` “Re-add Intrinsic::getDeclaration for out-of-tree code” restores a deprecated forwarding wrapper. History-only: LLVM 20 does not require deleting all old call sites to compile. |
| TargetTransformInfo signatures | verified | `9e462b7ea23e` “Use Align in TTI::getMemcpyLoopLoweringType”; `45c01e8a33bb` consolidates isVectorIntrinsic APIs; `0ad6be1927f8` improves getGatherCost. History-only; check actual fork overrides, do not mechanically change unrelated methods. `f590963db836` adds getPreferredAddressingMode for HasVendorXCVmem, a direct CORE-V postincrement reference. |
| MC fixup/relocation refactors begin | verified narrowly | `525f5262af81` “Support Parsing Nonstandard Relocations” adds RISCV_nonstandard.def and changes RISCVAsmBackend relocation lookup; `a15f1bfa949b` avoids isSymbolRefDifferenceFullyResolvedImpl. History-only. MCFixup.h itself has **no diff** between these release tags: a blanket MCFixup API rewrite at 20 is not supported by this evidence. |
| New-PM codegen migration / pipeline hooks | verified pipeline drift; migration not found in RISCVTargetMachine history | `bb3f5e1fed7c` “Overhaul the TargetMachine and LLVMTargetMachine Classes”; `0cbccb13d675` removes pre-RA vsetvli insertion; `1c94388f38c6` adds VLOptimizer and `169c32eb49fa` enables it; `9d02264b03ea` enables global merging; `2c782ab27187` adds software pipeliner. Re-evaluate PULP hook ordering using the final upstream pipeline. |
| RISC-V TableGen base-class changes | verified | `d280a9c5e226` “Refactor class RISCVExtension” removes explicit name argument, derives names from FeatureStdExt/FeatureVendor record prefixes and formats descriptions. High priority for registration and E004: preserve extension spelling/version/subtarget fields using CORE-V FeatureVendorXCV records as reference. `f93f925d4f3b` adds RVInst48/RVInst64; existing RVInst is retained. |
| llc/FileCheck pipeline drift | verified | Pipeline changes above require measuring O0/O3 tests and regenerating through policy; `14c4f28ec109` and `2967e5f8007d` enable load/store clustering, which may change instruction ordering. No test rewrite is authorized by this recon. |

## Release-note additions relevant to the fork

All rows below are verified against the indicated release-note section and history, unless a narrower evidence limit is explicitly stated.

| Change | Evidence | Fork impact |
|---|---|---|
| Explicit alignment fill is respected | LLVM RISC-V notes; `ea222be0d926` “Honour alignment directive fill value for non-intel” | MC tests/object bytes with explicit zero fill can change; preserve requested fill semantics. |
| Fixed RVV vectors require VLEN >=64 | LLVM RISC-V notes; `59728193a688` “Disable fixed length vectors with Zve32* without Zvl64b”; `c772f5d53a75` disables fixed vectors in getOptimalMemOpType at VLEN32; `950ee75909d9` fixes minimum-VLEN check | Audit v4i8/v2i16 PULP legality separately from RVV fixed-vector eligibility. |
| New CPU/scheduling definitions | LLVM RISC-V notes; SCR4 `9884fd33dbfe`, SCR5 `02645d66f938`, SCR7 `dbdf84388a82`, SiFive P470 `0c25f85e5b88`, P550 `5d03235c7347`, Hazard3 `9fa2386ff132`, TT Ascalon `41c86ca714a6`, MIPS P8700 `52e9f2c52cd1` | Reconcile registration/scheduling hunks without dropping fork CPUs. |
| Extension registrations | LLVM RISC-V notes; Zvbc32e/Zvkgs `a80a90e34b1f`, Smctr/Ssctr `0ca77f6656a7`, Svvptc `75c75fc16e8a`, Smdbltrp/Ssdbltrp `c17a914675f8`, Sha `35f6cc6af09f`, Sdext/Sdtrig `2fae5bdea7c2` | Preserve upstream generated ISA registration and reconcile fork insertion points. |
| Ratified extensions/profiles | LLVM RISC-V notes; Zacas `614aeda93b22`, pointer masking `2c0b34852af4`, RVA23 `ba7555e640ea`, RVB23 `7544d3af0e28` | ISA help/unit expected lists may grow; no permission to remove assertions. |
| Qualcomm assembler extensions | LLVM RISC-V notes; Xqcicsr `c4645ffedaca`, Xqcisls `8fcbba82d6c8`, Xqcia `6881c6d2a6ef`, Xqciac `1557eeda738d`, Xqcics `0614c601b44c`, Xqcilsm `668d9688ac8a`, Xqcicli `532a2691bc01`, Xqcicm `737d6ca44d38`, Xqciint `171d3edd0507`, Xqcilo `163935a48df6` | Additional vendor examples and assembler overlap; retain independent PULP predicates/encodings. |
| .insn wider encodings and expressions | LLVM RISC-V notes; `f93f925d4f3b`, `429387a71ce2` | Parser/disassembler/encoder insertion points change; keep PULP 32-bit encoding checks. |
| Inline asm constraints/modifiers | LLVM RISC-V notes; cr/cf/N `228f88fdc8e9`, R `4615cc38f35d`, cR `33c44074714d`, f with Zfinx `1bc1a79a65a9` | ISel and register class handling changes near fork code. `408659c5b5c7` merges GPRPair/GPRF64Pair (history-only companion). |
| Large code model | Clang RISC-V notes; `fef84c56dcd9` support, `dee058f9e3ae` macro | Reconcile target macro/driver and lowering edits; do not alter RV32 default configuration. |
| RVV intrinsic version 1.0 | Clang RISC-V notes; `05b3d26181ad` | Upstream RVV builtin tables change independently of PULP builtins. |
| Duplicate Zicsr/Zifencei allowed with g | Clang RISC-V notes; `a708fb737a78` | Upstream march parsing change; retain upstream checks. |
| Instruction pointer positioning deprecated | LLVM infrastructure notes (`5c126253ca4e`); implementation `79499f010d2b` and `2f50b280dc8e` deprecates legacy positioning APIs | Audit loop passes for debug-record preservation. Deprecation is not itself a reason to delete behavior. |
| ARMTargetDefEmitter feature bindings | LLVM TableGen notes added by `78729e5ae25e` | ARM-only; no direct fork impact. Exact causative commit not found in this recon. |

## Additional history-only high-priority facts

- **19/E002 is already upstream:** `508263824f4e` “Start moving X86Builtins.def to X86Builtins.td” implements `_Vector<N,T>` in ClangBuiltinsEmitter. `notes/19/E002.md` records the exact backport. At 20 keep upstream implementation once; resolve redundant backport hunks without losing GCC vector type strings. This is upstream replacement evidence, not permission to drop builtins.
- `970e2c1fe7e1` changes the builtins emitter to const RecordKeeper; `6d2534546582` removes CustomEntry. Check the fork builtin records against upstream TableGen rather than restoring obsolete escape hatches.
- CORE-V `00128a20eec2` adds XCValu Clang builtins; use current SemaRISCV.cpp and RISCVInstrInfoXCV.td as reference. `9d9d2b4799a6` renames cv.slet(u) to cv.sle(u) with aliases; this does **not** authorize renaming PULP instructions. `f672cc1ee1a4` introduces cond_code operand type for select/SFB pseudos.
- Clang SemaRISCV changes: `e8509a43acb2` checks per-function V extension features; `e3b22dcedb53` widens intrinsic size check state; `9cd93774098c` adds target_clones. Preserve PULP immediate diagnostics and feature checks when merging.
- `a2b9058c3929` reduces CSR lookup table size; `107f3efdbede` makes wrong-extension CSR diagnostics more detailed. Expect parser/help diagnostic drift but inspect actual failures first.

This list is preparation, not a completeness claim about all LLVM API changes or a green checkpoint. Step 20 build/lit and downstream oracle remain required.
