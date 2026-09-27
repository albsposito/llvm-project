# GVSoC2 `ri5ky_testbench`: bare-metal cycle-counting simulator

This setup runs bare-metal RV32 + XpulpV2 ELFs on the GAP9 SDK's GVSoC2 `ri5ky_testbench`
target and reports cycle counts. That target is a single RI5CY/GAP9 core
(`rv32imafc_zfinx` + PulpV2 + Gap9 + Int64), with 1 MB of RAM at 0x0 (latency 0) and boot
address 0x80. The MMIO block at 0x10000000 has four registers: +0 putchar, +4 exit, +8/+C
cycle counter low/high.

Status: **the simulator works.** GCC and clang builds of all three test programs run, print
output and return their exit code. The cycle counts repeat exactly from run to run.

## Files

| file | purpose |
|---|---|
| `build_gvsoc.sh` | Builds GVSoC2 with only the `ri5ky_testbench` target. It runs the same commands as `make gvsoc2.all`, but uses the venv and `-j24`. |
| `crt0.S` | Sets gp and sp, clears .bss, turns on PCER=0xFFF / PCMR=1 ("slow mode", see below), calls `main`, and writes the return value to the EXIT register. |
| `link.ld` | Places everything in the 1 MB RAM. `.text` starts at 0x80 (the boot address, also the ELF entry). The stack is 64 KB after .bss (`STACK_SIZE` overrides it). |
| `bench.h` | Header-only helpers, no libc needed: `bench_putchar/puts/print_u32/u64/i32/hex`, `bench_cycles()` (64-bit counter read hi/lo/hi with retry), `bench_cycles32()`, `bench_pccr_cycles()/bench_pccr_instr()` (CSR 0x780/0x781), and `bench_exit(code)`. |
| `run_sim.sh <elf> [gvrun args]` | Runs the ELF, prints its output and `[run_sim] exit code: N`, and exits with N. |
| `Makefile` | Builds `tests/{hello,loop,clip}.c` with GAP9 GCC (`out/*.gcc.elf`) and with port-20 clang (`out/*.clang.elf`). `make run` runs all of them. |
| `repro/` | Two port-20 clang crash reproducers (see "What doesn't work"). |

## One-time setup (already done on this host)

```bash
# apt build deps (installed by the owner): device-tree-compiler libfdt-dev flex bison
#   libsdl2-dev libsndfile1-dev libsamplerate0-dev libelf-dev python3-pip python3-venv
python3 -m venv /home/ubuntu/gvsoc-venv          # build_gvsoc.sh also creates it if it is missing
./build_gvsoc.sh > /home/ubuntu/gvsoc-build.log 2>&1   # env: SDK, VENV, JOBS=24, TARGETS=ri5ky_testbench
```

- The script pip-installs `gvsoc2/{gvrun,config_tree,core}/requirements.txt` into the venv. It then
  runs the SDK Makefile's `gvsoc2.bootstrap` + `gvsoc2.build` steps with
  `GVSOC_TARGETS=ri5ky_testbench`. I did not use `make` itself: the Makefile hard-codes `-j 6` and
  needs `GAP_SDK_HOME` from `sourceme.sh`. `gap.gap9.evk` is not needed, so it is not built.
- Output goes to `/home/ubuntu/gap_sdk_release/build/gvsoc2` and `.../install/gvsoc2`. The key
  file is `install/gvsoc2/lib/libplatform_tree_ri5ky_testbench.so`.
- **Build time: 30 s wall clock** (from scratch, 24 jobs, 32-core host, peak RSS 620 MB).
- **I modified no SDK source files** (`git status` in the SDK is clean). I installed no extra apt
  packages beyond the ones the owner approved.

## Everyday use

```bash
cd /home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/gap9-sweep/sim
make            # builds out/{hello,loop,clip}.{gcc,clang}.elf
make run        # runs them all
./run_sim.sh out/loop.clang.elf
```

`run_sim.sh` runs this command (from a temporary work dir):

```bash
env -u PYTHONPATH USE_GVRUN=1 USE_GVRUN2=1 PATH=/home/ubuntu/gvsoc-venv/bin:$PATH \
  /home/ubuntu/gap_sdk_release/install/gvsoc2/bin/gvrun --target=ri5ky_testbench \
  --work-dir=$WORK --parameter soc/binary=<elf> run
```

For a non-zero program exit, gvrun itself returns 1 and prints
`Platform returned an error (exitcode: N)`. `run_sim.sh` recovers N from that message. One
simulation takes about 0.6 to 0.9 s.

### Compile flags (from the Makefile)

```bash
# GAP9 GCC 7.1.1: compile and link with the GAP gcc driver / GNU ld
riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mabi=ilp32 -O2 -g -ffreestanding -fno-builtin -nostdlib -I sim \
    -nostdlib -static -T sim/link.ld crt0.S prog.c -lgcc -o prog.gcc.elf
# port-20 clang: compile, then link with ld.lld (this works; GNU ld was not needed)
clang --target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax \
    -isystem /home/ubuntu/gap_riscv_toolchain_ubuntu/riscv32-unknown-elf/include \
    -O2 -g -ffreestanding -fno-builtin -nostdlib -I sim -mllvm -pulp-loop-range-immediate=0 -c ...
ld.lld -nostdlib -static -T sim/link.ld crt0.o prog.o -o prog.clang.elf
```

`-mllvm -pulp-loop-range-immediate=0` works around a port-20 crash; see below. It makes clang
emit `lp.starti/lp.endi/lp.counti` in place of `lp.setupi`. That is one more instruction per
hardware loop than GCC, so keep it in mind when comparing cycle counts.

## Cycle counting / "slow mode"

According to `calib.h`, setting PCMR.active (CSR 0xCC1 = 1, with PCER 0xCC0 = 0xFFF) turns on the
RI5CY PCCR counters. It also forces GVSoC onto the slow, cycle-accurate executor instead of the
functional fast path. `crt0.S` does this by default. Build with `-DBENCH_FAST_MODE` to skip it.

- `bench_cycles()` reads the simulator clock through MMIO (+8/+C). It counts in both modes. This is
  the primary metric, and the one `calib.h` uses.
- `bench_pccr_cycles()` / `bench_pccr_instr()` only advance while PCMR.active=1. They read 0 in
  fast mode.
- In `loop.gcc`, slow and fast mode gave the same MMIO count (4018). Keep slow mode on anyway,
  since it is the documented cycle-accurate path.

## Validation results

**(1) hello** (text plus the cycles taken by a `bench_puts` call):
```
hello.gcc  : Hello from ri5ky_testbench (bare-metal) / cycles for puts: 249 / cycle counter now: 1355 / exit 0
hello.clang: Hello from ri5ky_testbench (bare-metal) / cycles for puts: 69  / cycle counter now: 267  / exit 0
```

**(2) timed 1000-iteration integer loop** (`acc += p[i] ^ (acc >> 3)`, trip count read from a
volatile). It is repeated 3 times inside one run, and the whole program was run twice. All counts
were identical:
```
loop.gcc  : run 0/1/2: mmio_cycles=4018 pccr_cycles=4028 pccr_instr=4025 result=-2118261029   (both invocations)
loop.clang: run 0/1/2: mmio_cycles=4021 pccr_cycles=4029 pccr_instr=4026 result=-2118261029   (both invocations)
```
The loop body is about 4 instructions per iteration (hardware loop, IPC ≈ 1). The first version
of this test used a constant trip count, and GCC folded the whole loop to a constant (7 cycles),
so the test now reads the trip count from a volatile.

**(3) `__builtin_pulp_clip(x, -128, 127)`**

| x | GCC build | clang build | expected |
|---|---|---|---|
| -1000 | -128 | **-64** | -128 |
| -129 | -128 | **-64** | -128 |
| -128 | -128 | **-64** | -128 |
| -65 | -65 | **-64** | -65 |
| -64 | -64 | -64 | -64 |
| 63 | 63 | 63 | 63 |
| 64 | 64 | **63** | 64 |
| 127 | 127 | **63** | 127 |
| 128 | 127 | **63** | 127 |
| 1000 | 127 | **63** | 127 |

The GCC build shows 0 mismatches (exit 0). The clang build shows 8 mismatches (exit 8).

Disassembly of `do_clip`:
```
GCC   (out/clip.gcc.o):   14851533   p.clip a0,a0,8
clang (out/clip.clang.o): 14751533   p.clip a0,a0,7      (clang -S prints "p.clip a0, a0, 7" too)
```
GVSoC's `p_clipi_exec` (`gvsoc2/core/models/cpu/iss/include/isa/pulp_v2.hpp:1930`) clamps to
`[-(1<<(imm-1)), (1<<(imm-1))-1]`. Immediate 8 therefore gives [-128,127], and 7 gives [-64,63].

**Verdict: only the GCC build gives the correct clamp to [-128,127].** The port-20 clang build
encodes `p.clip ...,7` and clamps to [-64,63]. This matches the survey's suspicion: clang computes
the immediate as log2(127+1) = 7, but GCC and the hardware expect log2(127+1)+1 = 8.

## What doesn't work / caveats

1. **port-20 clang crash, `lp.setupi` object emission.** Assertion
   `RISCVMCCodeEmitter.cpp:555 "Unhandled expression!"` fires for any constant-trip-count hardware
   loop. If you go through `-S` and then assemble, you get
   `immediate must be an integer in the range [0, 31]` on the `lp.setupi` end-label operand. Repro:
   `repro/lp_setupi_mc_crash.c`. Workaround: `-mllvm -pulp-loop-range-immediate=0`.
2. **port-20 clang crash (SIGSEGV) in the "PULP Hardware Loops" pass.** This happens for a loop
   with a runtime trip count whose body is pure arithmetic on the induction variable. Repro:
   `repro/hwloop_var_tripcount_crash.c` (`for(i=0;i<n;i++) acc+=i^(acc>>3);`). There is no
   command-line switch to turn the pass off. The only escape is `optnone`, or dropping
   `xpulpv2`. The same loop reading from memory (`acc += p[i]...`) compiles, so `tests/loop.c` uses
   that form.
3. GVSoC is instruction-accurate with a timing model, not RTL cycle-exact.
4. There is no libc/printf. Use `bench.h`. Bare-metal code must not call newlib (no syscalls are
   wired up).
5. `gap.gap9.evk` was not built. To add it, run `TARGETS="gap.gap9.evk ri5ky_testbench" ./build_gvsoc.sh`.
