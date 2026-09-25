# 20/conflict-clang-builtins: preserve both builtin families

## What upstream changed

`00128a20eec2` [RISCV] Implement Clang Builtins for XCValu Extension in CV32E40P (#100684) adds the XCV builtin table include at the previous end of BuiltinsRISCV.td. The fork adds its PULP include at the same position. The only conflict is `clang/include/clang/Basic/BuiltinsRISCV.td`, both modified.

## Why this is equivalent

Kept the upstream XCV include and appended the fork PULP include with its section heading. Neither table's entries, types, feature requirements, nor diagnostics were changed. The fork's builtin definitions and Sema/diagnostic files applied automatically. Upstream reference: clang/include/clang/Basic/BuiltinsRISCV.td:151 at llvmorg-20.1.8.

The E002 parser backport is already supplied upstream by `508263824f4e` [Clang] Start moving X86Builtins.def to X86Builtins.td (#106005). The upstream emitter retains both _Vector and _ExtVector parsing (clang/utils/TableGen/ClangBuiltinsEmitter.cpp:181); this pick introduces no emitter change and loses no GCC vector type support.

## What breaks if this is wrong

Missing either include would reject the corresponding CORE-V or PULP builtin calls. Losing _Vector parsing would reject PULP vector builtin table types. Checked conflict-marker absence and git diff --check; no build or tests run, as required for this resolver phase.

## Upstream reference

- Commit: `00128a20eec2` [RISCV] Implement Clang Builtins for XCValu Extension in CV32E40P (#100684)
- Commit: `508263824f4e` [Clang] Start moving X86Builtins.def to X86Builtins.td (#106005)
- Reference code: `clang/include/clang/Basic/BuiltinsRISCV.td:151` and `clang/utils/TableGen/ClangBuiltinsEmitter.cpp:181` at `llvmorg-20.1.8`.
- Release notes: not consulted; evidence from upstream history.
