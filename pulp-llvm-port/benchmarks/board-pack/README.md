# GAP9 board test pack

Everything in the PULP LLVM port has been checked only on the GVSoC simulator so far. This folder
holds a set of small programs to run on a real GAP9 board (a GAP9 EVK) with the GAP9 SDK's normal
`cmake --build build --target run` flow. They answer open questions that the simulator cannot
answer, and they check the simulator's results on silicon.

Every program checks its own results and prints them in a fixed format. One script runs them all
and puts every output into **one text file to send back**.

Pack version 2026-09-29. It was built and checked on the build server with GAP9 SDK 5.21.14,
GAP9 GCC 7.1.1 and our clang `20.1.8 (albsposito/llvm-project 75b4639bf455)`, which is the
integration build `build/int-20` of that day. Every program was run on GVSoC2 `gap.gap9.evk`,
and those outputs are in `sim-results/`.

Test 8 (`t8_vfmre_sign_b151`) was added on 2026-10-06 with the same SDK and GAP9 GCC. Its
prebuilt ELF and simulator log were made separately and the other 18 ELFs were not rebuilt.

## Quick start (what to run first)

```bash
# 1. copy the folder to the laptop (it includes prebuilt ELFs and the 66 MB clang tarball)
rsync -a <server>:/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/board-pack/ ~/board-pack/
cd ~/board-pack

# 2. the SDK environment you normally use for the board
source <your gap9 sdk>/configs/gap9_evk_audio.sh      # or your board's config
#    check that the SDK itself can run on the board (select your board in menuconfig if you
#    normally do; see "Board selection" below):
#    cd $GAP_SDK_HOME/examples/gap9/basic/helloworld && cmake -B /tmp/hw -DCONFIG_PLATFORM_BOARD=y \
#      && cmake --build /tmp/hw --target run

# 3. first a single short test with a known answer (about 1 minute)
scripts/run.sh t1_b101_gcc_hwloop
#    expected: "VERDICT B101 GCC hwloop bug on FC: REPRODUCED" and "=== END ... pass=20 fail=0"

# 4. optional: unpack our clang (Linux x86-64 with glibc >= 2.38, e.g. Ubuntu 24.04). Without it
#    the all-clang programs of test 7 run from the prebuilt ELFs instead of being rebuilt.
tar -xJf toolchain/pulp-clang-20-75b4639bf455-linux-x86_64.tar.xz -C toolchain/

# 5. everything (19 programs, 38 with "both"; a few minutes on the board)
scripts/run_all.sh              # builds from source with your SDK where possible (recommended)
#   scripts/run_all.sh both     # ... and also runs every prebuilt ELF (useful if your SDK differs)

# 6. send back the file it prints at the end:  results/board-results-<date>.txt
```

`run_all.sh` runs test 2 (hardware-loop alignment) last among the silicon probes. If a misaligned
hardware loop hangs the core, the results of the other tests are already saved. A program that
hangs is stopped after `PACK_TIMEOUT` seconds (default 300). Its log then ends with
`WARNING: no end marker`, and the script moves on to the next program.

## Requirements on the laptop

- The GAP9 SDK with its environment sourced (`GAP_SDK_HOME` set, `riscv32-unknown-elf-gcc` on
  `PATH`), and a board on which the SDK's `run` target already works (OpenOCD/JTAG as usual).
- `cmake`, `bash`, `timeout` (coreutils), `python3` (only for the test-6 cycle table).
- Our clang is optional (step 4 above). Only test 7 builds with it, and only when you want to
  rebuild the all-clang SDK apps yourself. Test 6 links prebuilt clang objects, and every other
  test uses GAP9 GCC only.

### Board selection

The scripts configure with `-DCONFIG_PLATFORM_BOARD=y`. The EVK version is a Kconfig choice,
and SDK 5.21.14 defaults to GAP9 EVK v1.3. If your board needs other options (EVK v2.0,
UART printf, ...), pass them to every configure through `PACK_CMAKE_ARGS`:

```bash
export PACK_CMAKE_ARGS="-DCONFIG_BOARD_GAP9EVK_V2_0=y"
```

The programs print with the SDK's default printf (semihosting over JTAG), so the output appears
in the terminal of the `run` target. The prebuilt ELFs were built for **SDK 5.21.14,
gap9_evk_audio, EVK v1.3**. If your board or SDK differs, prefer `run_all.sh` (source mode).
It rebuilds everything with your SDK. The only exception is the clang half of test 7 when you
have no clang, and even there the all-GCC half is rebuilt.

## What each test answers

In every test, **`CHECK ... PASS` means "same value as on the simulator"**. A `FAIL` on the board
is therefore the interesting outcome: silicon differs from GVSoC. The `VERDICT` lines say what
the values mean. Two tests differ:
- test 6: its CHECKs compare checksums with the GAP9 GCC reference, so a FAIL there is a wrong
  result;
- test 8: a CHECK passes when the probe ran and its result matched exactly one of the candidate
  formulas. Its CHECKs pass whichever side is right, and the `VERDICT B151:` line carries the
  finding. A difference from the simulator still shows up in the "difference to the simulator"
  section of the results file.

| test | question (backlog) | built by | simulator result (GVSoC2 gap.gap9.evk) |
|---|---|---|---|
| t1_b101_gcc_hwloop | Does GAP9 GCC's hardware-loop bug (count register replaced by the constant 1) give wrong results on silicon too? (B101) | GAP9 GCC | yes: -O2 and -O3 give 0x4b/0x4a instead of 0x40/0x4c, on FC and cluster; -Os, -O2/-O3 -mnohwloop correct |
| t2_hwloop_align_b68 | Do hardware loops need a 4-byte-aligned `lp.setup`/body (the fork's LLVM pads with a `c.nop`)? Does misalignment cost cycles? GCC `-mhwloopalign`? (B68) | GAP9 GCC (+ assembly) | all 20 aligned/misaligned cases correct for 5 trip counts; misaligned = no systematic cycle penalty (within +/-10 cycles per 100 iterations) |
| t3_fp16_vcmp_lanes_b99 | What do `vfeq/vfne/vflt/vfle/vfgt/vfge .h/.ah` write per lane: 0/1, 0/-1, or a bitmask? (design Q2, B99) | GAP9 GCC inline asm | **bitmask**: lane *i* true sets bit *i* (lane 1 only true = 0x00000002); NaN `vfne` = 0 |
| t4_shuffle_sci_h_b114 | Which immediate bit selects lane 1 in `pv.shuffle.sci.h`: bit 1 (LLVM) or bit 4 (GCC)? (B114) | GAP9 GCC inline asm | bit 0 / bit 1, so LLVM is right; GCC's `__builtin_shuffle(v,{1,1})` gives {v1,v0} |
| t5_shuffle2_order_b113 | In `pv.shuffle2.b/.h`, does a set selector bit pick `rs1` (manual, GCC) or `rD` (GVSoC)? (B113) | GAP9 GCC inline asm | `rD`: GVSoC swaps the sources; GCC's own two-vector shuffles come out wrong there |
| t6_kernels_clang_vs_gcc | Our clang vs GAP9 GCC on 12 real kernels (FIR int16/f32, 3 MatMul, MatVect f32, complex mag, FFT, dot products, clip, copy loop): same checksums? cycles? | clang or GCC (kernels), GCC (app) | all 4 builds x 2 cores correct; clang/GCC cycle geomean FC 1.104 (-O2), 1.119 (-O3); cluster 1.007 / 1.033 |
| t8_vfmre_sign_b151 | Does `vfmre.h` / `vfmre.ah` compute `rd - a*b` (GVSoC) or `a*b - rd` (what GAP9 GCC assumes when it emits it for packed `a*b - c`)? (B151) | GAP9 GCC (fixed instruction words + GCC C) | `rd - a*b` on FC and cluster, so GCC's packed `a*b - c` comes out negated; `vfmac` = `rd + a*b` |
| t7_sdk_apps_clang | SDK helloworld and perf built **entirely with our clang** through the SDK CMake flow; cluster core count (B107) | clang (whole app + SDK runtime C code) or GCC | gcc and clang-ccfix: 8 cluster cores run; plain clang: **0 cores** (B107) |

### Test 1: GAP9 GCC hardware-loop bug (B101)

The two reproducers from `benchmarks/hwloop-fuzz/triage-2026-09-28/gcc-bug/` are compiled five
times in one ELF: `-Os` (the SDK default), `-O2`, `-O2 -mnohwloop`, `-O3` and `-O3 -mnohwloop`.
They are:
- `checksum()` (issue-standalone.c): the correct result is 0x40;
- `kern()` (issue-standalone-gvsoc.c): the correct result is 0x4c.

The loop count comes from a volatile, so it is only known at run time. The functions run on the
FC and on the cluster controller.

- Simulator: `RESULT t1 variant=O2 ... checksum=0x4b kern=0x4a`, the same for O3, the others
  correct. `sim-results/t1_b101_disasm.txt` shows GCC's `lp.setupi x1,1`.
- On the board: if you see the same values, the bug is a real silicon-visible miscompile
  (the expected outcome, since it is a compiler bug). Any other value is news.

### Test 2: hardware-loop alignment (B68)

Part A is exact assembly (`hwl_cases.S`, assembled by GAP9 binutils). Each case exists twice:
- `_A`: `lp.setup` at an address = 0 mod 4 (as the fork's LLVM forces with a padding `c.nop`);
- `_M`: `lp.setup` at 2 mod 4 (as GCC emits).

main.c prints the real alignment of each case (`INFO case ... lp_mod4= body_mod4=`). The cases
are:
- `c2`: 2 compressed instructions, the minimum body;
- `w2`: 2 x 32-bit instructions;
- `cw` / `wc`: mixed; in `cw_A` the last instruction straddles a word;
- `mix3`: 3 instructions;
- `ld`: `p.lw` post-increment + add;
- `seti`: `lp.setupi`;
- `long`: `lp.starti/endi/count`, with the body start misaligned;
- `nest_XY`: nested x1/x0 loops, with the outer (X) and inner (Y) setup aligned (A) or
  misaligned (M).

Each case runs with trip counts 1, 2, 3, 5 and 100 and is checked. Then one call at n=100 is
timed.

Part B compiles four small C loops with GAP9 GCC `-O2`, `-O2 -mhwloopalign` and
`-O2 -mhwloopnorvc`, and checks them against `-O2 -mnohwloop`. The program scans its own code to
print where GCC put each `lp.setup` (`INFO hwloops ...`).

Reading the result:
- **All CHECKs PASS and `_M` cycles within a few cycles of `_A`:** the padding is unnecessary
  on silicon. B68 can drop the `setAlignment` in `PULPFixupHwLoops.cpp`, which saves one
  `c.nop` per loop entry (-1.1% on the FFT kernel).
- **A `_M` case FAILS (wrong count/sum, or the log stops):** misaligned hardware loops are
  broken on silicon. The padding is required and GCC's unaligned loops are a GCC bug.
  `-mhwloopalign` (part B) shows whether GCC's own option fixes them.
- **`_M` correct but consistently slower than `_A` (more than about 1 cycle per iteration):**
  alignment is a performance matter. Keep the padding for hot inner loops only, when the
  padding runs less often than the loop body.
- In `nest_AM` / `nest_MM` the padding `c.nop` sits inside the outer loop, so it runs 100 times:
  the +100 instructions there are the cost of padding itself.

Simulator (FC, cycles at n=100): c2 241/247, w2 251/242, cw 241/242, wc 241/242, mix3 341/342,
ld 241/242, seti 55/56, long 243/244, nest_AA 941, nest_AM 1041, nest_MA 942, nest_MM 1042. The
cluster is similar (ld 532 because of L2 latency). In part B, `-mhwloopalign` aligned only the
nested matmul loops, and `-mhwloopnorvc` also moved some loops to 0 mod 4. All variants gave the
same values.

### Test 3: packed fp16 compare lane values (Q2 / B99)

The test issues `vfeq/vfne/vflt/vfle/vfgt/vfge` in `.h` (IEEE half) and `.ah` (float16alt) on
four input pairs, one of which has NaNs. It then classifies the 36 non-NaN results against three
candidate formats:

| format | lane 1 only true | who expects it |
|---|---|---|
| bitmask: lane *i* sets bit *i* | `0x00000002` | both GVSoC models (ri5ky_testbench and gap.gap9.evk) |
| per-lane 0/1 | `0x00010000` | what `benchmarks/fp16-design/design.md` Q2 assumed GVSoC does |
| per-lane 0/-1 | `0xffff0000` | GAP9 GCC's vector select (`(a & m) \| (b & ~m)`) |

It also runs GCC's compiled `a < b` compare and select (`tests/vcmp.c`).

- Simulator: `VERDICT Q2 compare result format on cl: bitmask`, the same on the FC. `vfne(NaN)`
  gives 0, where IEEE says true. GCC's select gives 0x40004000, but C semantics want 0x40003c00.
- New finding from building this test: GVSoC does not give "0/1 per lane" as design Q2 said. It
  gives a **bitmask**. The earlier test only had lane 0 true, and there both formats read 0x1.
- On the board: the VERDICT line answers Q2 directly. The answer decides how LLVM must lower a
  vector fp16 compare and select. The cluster part runs first; the FC part comes after it, in
  case the FC lacks the packed fp16 unit.

### Test 4: `pv.shuffle.sci.h` immediate (B114)

The test issues all 64 immediates on rs1 = 0xBBBBAAAA and prints the results. From them it works
out which immediate bit selects each lane. It also runs GCC's `__builtin_shuffle(v, (v2s){1,1})`,
which GCC encodes as imm 17 = bit 0 + bit 4.

- Simulator: lane 0 = imm bit 0, lane 1 = imm bit 1 (LLVM's encoding). GCC's {1,1} gives
  0x11112222, which is {v1,v0}, a wrong result.
- On the board: lane 1 = bit 1 means GCC mis-encodes the instruction and must not be the
  reference for halfword sci shuffles. Lane 1 = bit 4 means LLVM and GVSoC are wrong.

### Test 5: `pv.shuffle2` source order (B113)

With rD = 0x44332211 and rs1 = 0x88776655, the test prints what every selector value picks. It
then runs GCC's two-vector `__builtin_shuffle`.

- Simulator: a set selector bit picks **rD**. GVSoC swaps the sources, so GCC's code gives
  0x22661155 instead of 0x66225511.
- On the board we expect the manual's order (set bit picks rs1). The CHECKs then FAIL, because
  they compare with the simulator, and the VERDICT reads "bit set -> rs1". That confirms B113 is
  a simulator bug.

### Test 6: our clang vs GAP9 GCC on real kernels

The test uses 12 kernels from `benchmarks/gap9-sweep`, with the same sources, drivers, input data
and flags. Eight are GAP9 SDK DSP library kernels, redistributed under their BSD licence. Four
were written for the sweep.

The kernels and their drivers are built into one library by one compiler
(`kernels/build_kernels.sh`):
- GAP9 GCC: `-march=rv32imcxgap9 -mPE=8 -mFC=1`;
- our clang: `--target=riscv32-unknown-elf -march=rv32imc_xgap9 -mabi=ilp32 -mno-relax`.

Each library is built at `-O2` and at `-O3`. The library is linked into a PMSIS app that GAP9 GCC
builds through the SDK. Each kernel runs once untimed and then 4 times timed. The cycle and
instruction counts come from the core's own counters (PCCR, the values that `pi_perf_read`
returns for `PI_PERF_ACTIVE_CYCLES` and `PI_PERF_INSTR`). The checksum is checked against the
GAP9 GCC reference. Everything runs on the FC and then on the cluster controller, with data in
L2.

- Source mode: the GCC libraries are built on the laptop. The clang libraries come from
  `prebuilt/kernels/clang-O?/`, and are rebuilt if `toolchain/clang-snap` exists.
- `scripts/compare_t6.py results/*t6_kernels.*.log` prints the clang/GCC table. The simulator's
  table is `sim-results/t6_compare.txt`:
  - FC -O2 geomean 1.104: clang is slower on `copy_loop` (2.0x, a missed hardware loop), `clip`
    (1.24x), `matvect_f32` (1.33x, no post-increment) and `matmul_worker` (1.10x). It is faster
    on `fir_f32` (0.93x).
  - Cluster geomean 1.007, because L2 latency dominates there.
- The cycle counts on silicon include real memory latency and caches, so they are not expected
  to match GVSoC. The ratios are what counts. Every checksum must PASS for every build.

### Test 7: SDK example apps built entirely with our clang

`t7_sdk_apps_clang/build_clang_app.sh <app> board <build dir> <variant>` builds with the SDK's
own CMake flow. The file `sdk-clang/clang-gap9.cmake` swaps in a GCC-compatible clang wrapper,
and no SDK file is edited. With it, our clang compiles every C file of the app and of the SDK
runtime (FreeRTOS, PMSIS, drivers). GAP9 GCC assembles the runtime's `.S` files and GNU ld links
("setup A" in `benchmarks/sdk-clang/report.txt`). There are three variants:

- `gcc`: the SDK default, as the reference;
- `clang`: our clang alone. The two PMSIS builtins that needed `gap9_clang_compat.h` before
  (`__builtin_pulp_event_unit_read_fenced`, `__builtin_pulp_OffsetedWritePtr`) are now native
  since task 20/F016 landed, so no workaround header is used;
- `clang-ccfix`: as `clang`, plus `gap9_clang_compat.h` force-included. It folds
  `__builtin_pulp_CoreCount()` to 8 as GCC does.

**Known bug, B107:** our clang still reads `__builtin_pulp_CoreCount()` from the wrong address,
which gives 0 on GAP9. The fix is task 20/F018, not landed in this compiler. So in the plain
`clang` variant, cluster team forks run on **0 cores**, silently:
- helloworld prints no `[0 x] Hello World!` lines from the cluster;
- perf prints `Perf : 0 cycles` for cores 0-7;
- `t7_corecount` prints `cores_that_ran=0` and `VERDICT B107 ... NO core ran`.

`clang-ccfix` shows what the apps do once F018 lands. The apps are helloworld and perf (straight
from `$GAP_SDK_HOME/examples/gap9/basic`, copied into the build directory first) and
`t7_corecount`. `t7_corecount` prints the builtin's value, `pi_cl_cluster_nb_cores()` and how
many cores actually ran.

The simulator agrees with all of this:
- gcc and clang-ccfix: 8 cores and the full helloworld output;
- clang: `__builtin_pulp_CoreCount()=0 ... cores_that_ran=0`.

### Test 8: sign of `vfmre.h` (B151)

For the packed float16 expression `a*b - c`, GAP9 GCC emits `vfmre.h c, a, b`. GVSoC executes
`vfmre.h rd, rs1, rs2` as `rd = rd - rs1*rs2`, the opposite sign. GCC's float16 and float16alt
FFT is therefore wrong on the simulator, and only silicon can say which side has the bug.

Part 1 runs the instruction itself, with no compiler code generation involved:
- Each probe is a fixed 32-bit word with fixed registers (`vfmre.h a0, a1, a2` = `0x92c5a533`).
  Next to it the same mnemonic is assembled by the toolchain, and the program checks at run
  time that the two words are equal (`RESULT t8 encoding ...`).
- The program also scans GCC's code for the C expression and prints the instruction found there
  (`RESULT t8 compiled_code float16 a*b-c: vfmre.h=0x92b52633`). It is the probe's instruction
  with other registers. `sim-results/t8_b151_disasm.txt` shows the same from the disassembly.
- The inputs are small integers, exact in both formats and different per lane: rd={10,1},
  a={2,3}, b={4,5}, then rd={4,-20}, a={-3,7}, b={5,2}. Each `RESULT ... out=` line prints the
  raw result next to the candidate values, so the log is evidence on its own.
- The result is matched against `rd - a*b`, `a*b - rd`, `rd + a*b` and `-(rd + a*b)`, each
  with b per lane or with one lane of rs2 used for both lanes. The candidates are computed with
  integer arithmetic.
- Probed: `vfmre.h` and `vfmre.ah`, with `vfmac.h` and `vfmac.ah` as controls (expected
  `rd + a*b`). The `.r` forms (`vfmre.r.h`, `vfmac.r.h`, `.r.ah`) are extra controls and run
  last, after the verdict is printed.

Part 2 compiles packed `a*b - c`, `c - a*b` and `a*b + c` with the compiler that builds the
test, and compares each with the same expression done lane by lane in scalar arithmetic
(`MATCH` / `MISMATCH`).

How to run it and read it:

```bash
scripts/run.sh t8_vfmre_sign_b151        # about 1 minute; output in results/t8_vfmre_sign_b151.log
grep '^VERDICT B151' results/t8_vfmre_sign_b151.log
```

The last `VERDICT B151:` line is the answer. It needs both cores to agree, `vfmre.ah` to agree
with `vfmre.h`, and both `vfmac` controls to give `rd + a*b`:
- `VERDICT B151: vfmre.h and vfmre.ah compute rd - a*b on this target (same as GVSoC) => ...
  GAP9 GCC emits the wrong instruction for a*b - c`: silicon agrees with GVSoC. It is a GAP9 GCC
  bug, and GCC's float16 FFT is wrong on the chip too. The compiled-code line then shows
  `float16 a*b-c MISMATCH`.
- `VERDICT B151: vfmre.h and vfmre.ah compute a*b - rd on this target (not what GVSoC does) =>
  ... GVSoC models vfmre with the wrong sign and GAP9 GCC's code is right`: a simulator bug. The
  compiled-code line then shows `float16 a*b-c MATCH`.
- `VERDICT B151: inconclusive (...)`: the line lists what each probe computed on each core.

Simulator: `rd - a*b` for `vfmre.h` (0xcb004000 for set 0, where `a*b - rd` would be
0x4b00c000) and for `vfmre.ah`, on both cores. `vfmac` gives `rd + a*b`. The `.r` forms do the
same with lane 0 of rs2 in both lanes. GCC's compiled `a*b - c` is a MISMATCH, and `c - a*b` and
`a*b + c` MATCH. All 17 CHECKs pass.

The cluster part runs first, as in test 3. If the output stops after an `INFO starting ...`
line, that core does not implement the instructions named there, and the VERDICT lines printed
before it still hold.

The test can also be built with our clang (`t7_sdk_apps_clang/build_clang_app.sh
$PWD/t8_vfmre_sign_b151 board <build dir> clang`). It is not needed for the answer. Clang does
not emit `vfmre` for `a*b - c`, so its three float16 expressions MATCH, and the float16alt half
of part 2 is left out there (clang needs a soft-float helper that the GAP9 libgcc lacks).

## Layout

```
README.md                 this file
common/                   pack.h/pack.c (printing, checks, cluster launch, PCCR counters),
                          pack.cmake (per-file flags, prebuilt-ELF hook), runner/ (placeholder app
                          used to run prebuilt ELFs), Kconfig + sdk.config (cluster driver on)
t1_b101_gcc_hwloop/       test 1 (main.c + b101_kernels.inc compiled 5 ways)
t2_hwloop_align_b68/      test 2 (hwl_cases.S, hwl_c.inc compiled 4 ways, main.c)
t3_fp16_vcmp_lanes_b99/   test 3
t4_shuffle_sci_h_b114/    test 4
t5_shuffle2_order_b113/   test 5
t6_kernels_clang_vs_gcc/  test 6: main.c (app), kernels/ (src, drivers, gen = SDK extracts, shim,
                          rt.h, build_kernels.sh)
t7_sdk_apps_clang/        test 7: build_clang_app.sh, sdk-clang/ (wrapper, cmake cache file,
                          compat header), t7_corecount/
t8_vfmre_sign_b151/       test 8
scripts/run_all.sh        run everything, then collect_results.sh
scripts/run.sh            build one test from source and run it:  scripts/run.sh <test dir>
scripts/run_prebuilt.sh   run one prebuilt ELF:  scripts/run_prebuilt.sh prebuilt/board/<x>.elf
scripts/collect_results.sh  results/*.log -> results/board-results-<date>.txt (summary, VERDICTs,
                          FAILs, test-6 table, per-line diff against sim-results/, full logs)
scripts/build.sh          configure + build one test (board or gvsoc)
scripts/compare_t6.py     clang/GCC cycle table from test-6 logs
scripts/server/           how prebuilt/ and sim-results/ were made on the build server
prebuilt/board/*.elf      19 ELFs (board config): t1..t5, t8, t6_kernels.{gcc,clang}-O{2,3},
                          t7_{helloworld,perf,corecount}.{gcc,clang,clang-ccfix}
prebuilt/kernels/         the test-6 kernel libraries (+ disassembly, build log)
prebuilt/MANIFEST.txt     sha256 of every prebuilt file, SDK/compiler versions
sim-results/              GVSoC output of every prebuilt ELF (the "simulator result"),
                          t6_compare.txt, t1_b101_disasm.txt, t2_cases_disasm.txt,
                          t8_b151_disasm.txt
toolchain/                our clang snapshot (tarball; not in git)
```

To run one test by hand, the plain SDK way:

```bash
cd t4_shuffle_sci_h_b114
cmake -B build -DCONFIG_PLATFORM_BOARD=y $PACK_CMAKE_ARGS
cmake --build build --target run
```

To run a prebuilt ELF by hand:

```bash
cmake -S common/runner -B build/runner -DCONFIG_PLATFORM_BOARD=y -DPACK_PREBUILT_ELF=$PWD/prebuilt/board/t6_kernels.clang-O2.elf
cmake --build build/runner --target run
```

## Reporting back

Send `results/board-results-<date>.txt` (one file, with every log inside). If something fails to
build, the matching `results/<test>.build-failed.log` is included in it too. Useful extra
information: the board (EVK version) and the SDK version, if they differ from the file's header.

## How this pack was verified (server side)

- `scripts/server/make_all.sh` built the 18 prebuilt board ELFs with the SDK mirror of
  `benchmarks/sdk-clang/setup.sh`. The SDK itself was not modified. The script then ran each ELF
  on GVSoC2 `gap.gap9.evk`: the board-config ELFs run there unchanged. Result: every check
  matches its expected simulator value. The only CHECK FAIL is the plain-clang `t7_corecount`,
  which is the B107 bug.
- `scripts/run_all.sh both` was run end to end with `PACK_PLATFORM=gvsoc`: 36 programs, built
  from source and prebuilt. Every output matched `sim-results/` line by line, cycle counts aside.
  This also exercised the prebuilt-ELF runner, the SDK `run` target and `collect_results.sh`.
- The clang tarball was unpacked and used to rebuild `t7_corecount` (clang-ccfix), which ran
  correctly.
- Test 8 (2026-10-06): built for the board with `scripts/build.sh` and run on GVSoC2
  `gap.gap9.evk` (`sim-results/t8_vfmre_sign_b151.log`). `scripts/run.sh`,
  `scripts/run_prebuilt.sh` and `collect_results.sh` were run on it with `PACK_PLATFORM=gvsoc`,
  and both outputs matched `sim-results/`. The two other verdicts (`a*b - rd` and
  `inconclusive`) were checked with a scratch copy in which the `vfmre` probes were replaced by
  `vfmul` + `vfsub`. It was also built with our clang 20.1.8 (26e7268c3127) and run on GVSoC.
- Not verifiable here: JTAG loading, real memory timing and anything silicon-specific. That is
  the purpose of this pack.

Known GVSoC limitation: pi_perf_start() on the cluster controller touches the cluster timer,
which GVSoC does not model. The pack therefore programs the core's PCCR counters directly
(`common/pack.c`), and does the same on the board.
