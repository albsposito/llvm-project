# 20/T010: regen report

New test files only, under owner exception B40 (`notes/20/owner-test-exceptions.md#b40`). No existing test is modified. `git diff --stat abe1ba6bf62d..work/20/T010` lists 9 new files and nothing else. All expected output comes from `build/int-20` (integration head `abe1ba6bf62d`).

Script and command used (one line per test file):

- `llvm/test/CodeGen/RISCV/xpulp-clip-extract-imm.ll`: `llvm/utils/update_llc_test_checks.py --llc-binary build/int-20/bin/llc`
- `llvm/test/CodeGen/RISCV/xpulp-hwloop-countdown.ll`: `llvm/utils/update_llc_test_checks.py --llc-binary build/int-20/bin/llc`
- `llvm/test/CodeGen/RISCV/xpulp-hwloop-layout.ll`: `llvm/utils/update_llc_test_checks.py --llc-binary build/int-20/bin/llc`
- `llvm/test/CodeGen/RISCV/xpulp-postinc-f32.ll`: `llvm/utils/update_llc_test_checks.py --version 5 --llc-binary build/int-20/bin/llc`
- `llvm/test/CodeGen/RISCV/xpulp-lsr-postinc-heuristic.ll`: `llvm/utils/update_llc_test_checks.py --llc-binary build/int-20/bin/llc`
- `llvm/test/CodeGen/RISCV/xpulp-postinc-f32-mir.ll`: `llvm/utils/update_mir_test_checks.py --llc-binary build/int-20/bin/llc`
- `llvm/test/CodeGen/RISCV/xpulpv2-simd-cost-model.ll`: `llvm/utils/update_analyze_test_checks.py --opt-binary build/int-20/bin/opt`
- `llvm/test/CodeGen/RISCV/xpulp-hwloop-obj.ll`: no update script handles `llc -filetype=obj | llvm-objdump`. The file has 9 hand-written CHECK lines. They are the instruction words and disassembly that int-20's `llvm-objdump -d -r` prints, and `--implicit-check-not=R_RISCV` asserts that no relocation is left.
- `clang/test/CodeGen/RISCV/riscv-xpulpv2-rn-builtins-range.c`: a `-fsyntax-only -verify` test with no CHECK lines. Its `expected-error` texts are the ones proposed in `tasks/20/F001.result.json`, and int-20 emits exactly those.

I reran every scripted file through its update script on the final tree. The output is byte-identical, so no scripted CHECK line was edited by hand.

Per new file (none of them changes an existing CHECK block, so the cosmetic/semantic classification of changed blocks does not apply; every block is new):

| Test file | Guards | Functions | Class | Before: port-20 (port-20-green) | Isolating toolchain | After: int-20 |
|---|---|---|---|---|---|---|
| clang/test/CodeGen/RISCV/riscv-xpulpv2-rn-builtins-range.c | 20/F001: Round must equal 2^(Norm-1), Norm in [0,31] | rn_valid (4 valid calls), rn_invalid (3 errors) | new | FAIL: valid calls rejected, expected errors not seen (7 errors) | port-20fix (F001 in): PASS | PASS |
| llvm/test/CodeGen/RISCV/xpulp-clip-extract-imm.ll | 20/F002: p.clip/p.clipu width immediate, p.extract[u] size-1 | clip_i8/i16/i1, clipu_u8, extract_8_8, extractu_8_8, extractu_32_0 | new | FAIL: "Cannot select" on extractu_32_0; per function, `p.clip ...,7` instead of 8, `p.extract ...,8,8` instead of 7,8 | port-20fix (F002 in): PASS | PASS |
| llvm/test/CodeGen/RISCV/xpulp-hwloop-countdown.ll | 20/F003: count-down latch (`icmp eq %i.next, 0`) → `lp.setup x0, <n>`; constant 31 → `lp.setupi x0, 31` | countdown, single31 | new | FAIL: crash in "PULP Hardware Loops" on @countdown | port-20fix (no F003): FAIL, same crash; port-20fix2 (F003 in): PASS | PASS |
| llvm/test/CodeGen/RISCV/xpulp-hwloop-layout.ll | 20/F005: fixup pass on rotated latch, compare-only latch, and a tail-duplicated latch (no hwloop) | latch_above_header, empty_latch, seed22_taildup | new | FAIL: crash in "PULP Hardware Loop Fixup" on @latch_above_header (seed22_taildup wrongly got an lp.setup) | port-20fix (no F005): FAIL, same crash; port-20fix2 (F005 in): PASS | PASS |
| llvm/test/CodeGen/RISCV/xpulp-hwloop-obj.ll | 20/R001: lp.setupi / lp.setup / lp.starti+lp.endi+lp.counti encoded in an object with no relocation | work (1000 iterations), workn (variable n); 2 RUN lines | new | FAIL (first crash is F003's, on @workn); @work alone: assertion "Unhandled expression!" in RISCVMCCodeEmitter (the R001 defect, `logs/20-T010.r001-isolate.log`) | @work alone on port-20fix (R001 in): `3e84507b lp.setupi x0, 0x3e8, 0x8`; whole file needs F003 too, PASS on port-20fix2 | PASS |
| llvm/test/CodeGen/RISCV/xpulp-postinc-f32.ll | 20/F006 (asm): Zfinx f32 loads are `p.lw rd, 4(rs!)` / `p.lw rd, rs2(rs!)`; f32 store stays `sw`; with +f, `flw`, no p.lw | dot, dot_stride, scale_store; RUN prefixes ZFINX and F | new | FAIL (crash in "PULP Hardware Loops" on @dot_stride, the F003 defect) | port-20fix2 (lacks only F006): FAIL, `lw` instead of `p.lw` at ZFINX lines 34 and 111 | PASS |
| llvm/test/CodeGen/RISCV/xpulp-postinc-f32-mir.ll | 20/F006 (MIR, `-verify-machineinstrs`, `-stop-before=pulp-hwloops`): `P_LW_ri_PostIncrement` / `P_LW_rr_PostIncrement` feeding FMADD_S_INX / FADD_S_INX via `COPY ... .sub_32`; `SW_INX` store | dot, dot_stride, scale_store | new | FAIL: no P_LW_*_PostIncrement at lines 50 and 113 | port-20fix2: FAIL, same lines | PASS |
| llvm/test/CodeGen/RISCV/xpulpv2-simd-cost-model.ll | 20/F004: cost of load/store, arithmetic, insert/extract element, shuffle, select, casts, reduce on `<2 x i16>`/`<4 x i8>` without V, throughput and code-size | mem, arith, misc; RUN prefixes THRU and SIZE | new | FAIL: assertion "Tried to get vector length without Zve or V extension support!" in both RUN lines | port-20fix (F004 in): PASS | PASS |
| llvm/test/CodeGen/RISCV/xpulp-lsr-postinc-heuristic.ll | 20/E007: Xpulpv2 `getPreferredAddressingMode` = AMK_PostIndexed, so the second pointer keeps `p.lbu a1, 1(a3!)` in the loop (IR identical to upstream `xcvmem-heuristic.ll` at llvmorg-20.1.8) | test_heuristic | new | PASS: E007 landed before port-20-green, so no "before" toolchain exists | probe build with `if (ST->hasPULPExtV2())` disabled (`logs/20-T010.e007probe.diff`, reverted; restored llc is cmp-identical to int-20): FAIL at line 16, plain `lbu` after the loop | PASS |

Instruction-mix check for the whole file (CHECK lines; there is no "before" because each file is new):

| File | `lp.` | post-inc `p.l*/p.s*` | `pv.` | `p.mac` | `frep.` | `scfg*` | `p.clip`/`p.extract` |
|---|---|---|---|---|---|---|---|
| xpulp-clip-extract-imm.ll | 0 | 0 | 0 | 0 | 0 | 0 | 7 |
| xpulp-hwloop-countdown.ll | 2 (`lp.setup`, `lp.setupi`) | 1 | 0 | 0 | 0 | 0 | 0 |
| xpulp-hwloop-layout.ll | 2 (`lp.setup`; none in seed22_taildup) | 1 | 0 | 0 | 0 | 0 | 0 |
| xpulp-hwloop-obj.ll | 6 (`lp.setupi`, `lp.setup` x2, `lp.starti`, `lp.endi`, `lp.counti`) | 0 | 0 | 0 | 0 | 0 | 0 |
| xpulp-postinc-f32.ll | 6 (`lp.setup`, both prefixes) | 3 (ZFINX only) | 0 | 0 | 0 | 0 | 0 |
| xpulp-postinc-f32-mir.ll | n/a (MIR); 3 `P_LW_*_PostIncrement`, 2 `SW_INX` | | | | | | |
| xpulp-lsr-postinc-heuristic.ll | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| xpulpv2-simd-cost-model.ll | n/a (cost printout) | | | | | | |
| riscv-xpulpv2-rn-builtins-range.c | n/a (diagnostics) | | | | | | |

Notes:
- No `-verify-machineinstrs` on the full-pipeline hardware-loop RUN lines (countdown, layout, obj, postinc-f32 asm). The PULPFixupHwLoops verifier finding predates this step (PROGRESS.md escalations, T007 worker), and F003's proposal asks not to add the flag yet. The MIR test stops before the hardware-loop passes and does use the verifier.
- Placement: the F004 and F001 tests live in `llvm/test/CodeGen/RISCV` and `clang/test/CodeGen/RISCV`, not `Analysis/CostModel/RISCV` and `clang/test/Sema`, because the harness lit suite (`config.env` `LIT_PATHS`) runs only the former.
- `data/fork-tests.txt` already lists all nine paths (harness commit `77e0563d8a0b`), so no harness data change was needed.
- lit (`scripts/wlit.sh wt/20-T010 build/20-T010 -v <9 tests>`): 9/9 PASS, `logs/20-T010.lit.log`. Before/after matrix: `logs/20-T010.before-after.log`.
