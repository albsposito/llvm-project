# Independent review of test-policy proposals

Scope: read-only review of the T002 and T004 proposals, not approval of a worker branch. Neither result contains a fix commit. No landing APPROVE is issued; policy_check and commit-diff review remain required when branches exist.

## T002: instruction display

Verified `git show --stat` and the implementation diff for b27f86b40b20942c0e809128214b43d6edde365a, `[RISCV] Add an instruction PrettyPrinter to llvm-objdump (#90093)`. The commit is an ancestor of llvmorg-19.1.7 and not of task prev_tag e6c3289804a67ea0bb6a86fadbe454dd93b8d855. RISCVPrettyPrinter reads each four-byte instruction as a little-endian uint32_t and prints eight hexadecimal digits. This changes display, not instruction byte order in the object.

Independently parsed all proposed CHECK-DISASM lines in T002.md and compared them with the unchanged worker tests. All 18 proposed checks preserve every encoding bit after reversing the four displayed bytes, and preserve full mnemonic/operand tokens and ordering: xdma 8, xfrep 3, xmempool 1, xssr 6. The worker's saved assembly/disassembly evidence separately reports equivalent actual output. This review did not rerun that assembly/disassembly.

Exact exception needed: allow a test-regen worker, for these four named `llvm/test/MC/RISCV/rv32{xdma,xfrep,xmempool,xssr}-valid.s` files only, to mechanically replace the 18 CHECK-DISASM four-byte display fields with their eight-digit little-endian word representations, despite rule 3's LLVM-update-script-only requirement. Whitespace alignment may change; encoding bits, mnemonic/operand tokens, check count/order, CHECK-INST/CHECK-ENCODING lines, input assembly, and RUN/availability directives must remain identical. Require a cosmetic regen report, trailers, independent final diff review, and all four actual lit tests passing. No semantic-instruction exception is justified or needed.

## T004: missing-feature diagnostics

Verified `git show --stat` and relevant Sema/test diffs for 13b653ab112736b92cd7f8ef249ced2b148ee7f4, `[clang][RISCV] Enable RVV with function attribute __attribute__((target("arch=+v"))) (#83674)`. It is also in the task prev_tag..llvmorg-19.1.7 range. Upstream removes the global Sema feature loop and migrates builtin diagnostics to `'<builtin>' needs target feature <features>` in riscv64-zbkb-error.c. Upstream also adds -S there; this fork test already has -S, so no RUN change is needed.

Independently checked all 91 entries of T004.diagnostic-proposal.json against the unchanged source and worktree-repro log: each old string exists at its specified line, each proposed string names the exact builtin called there and requires xpulpv, and each occurs in the actual diagnostics at that same source line. The test retains its riscv32 target without +xpulpv. These proposals preserve the observable rejection coverage for all 91 calls and make the checked diagnostic builtin-specific. This evidence does not establish general target-attribute behavior, and no claim of such broader coverage is necessary for this migration.

Exact exception needed: reassign to test-regen and allow only the 91 expected-error annotation bodies at lines 8–98 of `clang/test/CodeGen/RISCV/riscv-xpulpv2-intrinsics-diag.c` to be mechanically replaced by the exact entries in T004.diagnostic-proposal.json, despite rule 3 limiting updates to CHECK lines from LLVM update scripts. All calls, arguments, function body, RUN lines, availability directives, annotation count and source-line association must remain unchanged. Keep the literal builtin identity and xpulpv feature requirement; no wildcard or generalized error expectation. Require report/trailers, independent final diff review, and passing actual lit verification. The existing worker role is not authorized to make this edit under rule 2.

## Other evidence

At completion of this review, `tasks/19/T005.result.json` and `notes/19/T005.md` were both absent. T005 has therefore not been reviewed here. The exceptions above concern only T002 and T004 and confer no authority for other test updates.

## Follow-up independent review: T001, T003, T005

This follow-up supersedes the earlier statement that T005 was unavailable. It reviews evidence and an unapplied proposal only; it does not approve any branch or authorize an exception. All seven upstream commits cited below were independently verified to be ancestors of llvmorg-19.1.7 and outside the task's prev_tag e6c3289804a67ea0bb6a86fadbe454dd93b8d855.

### T005: extension-help padding and registration

Independently parsed `T005.proposed.patch`: exactly 26 removed/added row pairs; each added row equals its old row with exactly one ASCII space inserted immediately before the version. Names, versions, order, and other text are identical. Compared against `logs/19-T005.actual.txt`: five proposed rows already occur in actual output, and 21 are missing. Independently extracted the 21 names from the E004 commit's added RISCVExtension declarations; their set is exactly the missing-row set, all at version 0.1. This verifies the two distinct causes, without claiming the unapplied patch passes a rebuilt unit test.

Verified the production diff in upstream `207e45fb67ee3dbec9590d9303eebf4f720c8a40`, `[RISCV] Add back SiFive's cdiscard.d.l1, cflush.d.l1, and cease instructions. (#83896)`: PrintExtension changes `left_justify(Name, 20)` to width 21. Registration is separately covered by upstream `80628ee0d555`, `[RISCV] Generate RISCVISAInfo table from RISCVFeatures.td. (#89955)` and E004. Padding cannot restore missing registrations, and dropping those rows would weaken coverage.

Exact exception needed: a test-regen worker may apply only the 26 single-space insertions in `notes/19/T005.proposed.patch` to the C++ raw-string expected output in `llvm/unittests/TargetParser/RISCVISAInfoTest.cpp`, despite rule 3's CHECK-only/updater-only restriction. Preserve all assertions and every expected extension/version. Land E004 separately, then rebuild/run the actual TargetParserTests suite, requiring all 83 tests to pass. Require note/report/trailers and independent final diff review. No instruction-semantic exception is involved.

### T001: FREP dead CSR destinations

Independently diffed `logs/19-T001.no-dead.s` and `logs/19-T001.actual.s`: the entire difference is exactly six instructions, three csrrsi and three csrrci, whose dead destination registers disappear in the printed csrsi/csrci aliases. Every CSR address is 1984 and every immediate is 1 in both outputs. FREP instructions, arithmetic, labels, instruction order and all other assembly text are unchanged. This comparison uses saved worker runs; this review did not rerun the compiler.

The source explains the change: `RISCVExpandSSRInsts.cpp:418-431` explicitly creates dead GPR definitions for these CSR operations; `RISCVDeadRegisterDefinitions.cpp:92-103` replaces eligible dead virtual definitions with X0. `RISCVInstrInfo.td:1003-1004` defines csrsi/csrci as aliases of CSRRSI/CSRRCI with X0 destination. Upstream `52187b9f2e7ef0997269bcf64b3d2512a52467ed`, `[RISCV] Move RISCVDeadRegisterDefinitions to post vector regalloc (#90636)`, moves that pass from addPreRegAlloc to the allocation hooks, explaining why it now sees the fork expansion.

Exact exception needed under strict rule 3: reassign T001's actual FileCheck update to test-regen, use LLVM's update_llc_test_checks.py, and permit only these six dead-destination changes and resulting aliases in `llvm/test/CodeGen/RISCV/freploop-nested.ll`. Conservatively classify affected blocks as semantic under the literal instruction-replacement rule and explicitly record the exception; do not silently label the changed printed mnemonics cosmetic. Underlying CSRRSI/CSRRCI opcode families and CSR effects are preserved, but destination encoding changes. Preserve the normal production pass and RUN lines; require actual lit PASS, unchanged normalized remaining instruction sequence, report/trailers and independent final diff review. This evidence grants no general approval for other instruction changes or pass-order changes.

### T001/T003: upstream test identity

Independently checked upstream summaries: `785570319423`, `[RISCV] Move vp.splice tests into rvv directory. NFC`, contains four 100% renames; `b13f79961693`, `[RISCV] Fix spelling error in test names. NFC`, contains two 100% spelling renames. `10a55caccf4e`, `[RISCV] Support constraint "s" (#80201)`, deletes the uppercase-S file and creates the lowercase-s and error files; it is a replacement, not an exact rename. `0afc884e8740`, `[RISCV] Use vnclip for scalable vector saturating truncation. (#88648)`, reports a 90% rename to fixed-vectors-trunc-sat-clip.ll and creates trunc-sat-clip-sdnode.ll. All eight mapped destinations independently match PASS records in lit-r1/lit.json.

No rule 3 test-edit exception is needed for explicit harness identity mappings that retain both historical identities and required current PASS checks. The two non-exact replacements require their upstream coverage evidence, rather than being presented as byte-identical renames. This review does not approve H001's implementation; its independent diff and regression checks remain necessary. No test files may be renamed/deleted locally or dropped from coverage to implement these mappings.
