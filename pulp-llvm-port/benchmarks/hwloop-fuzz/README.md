# Random-loop fuzzer (hardware loops)

Generates random C loop nests, compiles them with the clang under test, runs them on
GVSoC and compares the result with a trusted reference. It exists to find
hardware-loop wrong code, hangs and crashes in the PULP back end.

## Files

| file | what it is |
|------|------------|
| `gen.py <seed>` | prints a random kernel `kern(A, B, out, n, m, k)` (unsigned arithmetic, masked indices, no UB) |
| `drv.c` | GVSoC driver: fills A/B, calls `kern` with the bounds `-DN_ -DM_ -DK_`, prints `RES <result> <hash of out[]>` |
| `hdrv.c` | the same driver for the host (printf) |
| `one.sh <seed>` | one seed: prints one status line |
| `run.sh <first> <last> [jobs]` | a seed range in parallel; status lines on stdout, summary on stderr |
| `triage-2026-09-28/` | the triage behind the current reference (report.txt, GCC reproducer in gcc-bug/) |

## Usage

Run from any directory; work files go to `$WD/<seed>` (default `./w/<seed>`).

```
NEW=<your build>/bin BASE=/home/ubuntu/llvm-project/pulp-llvm-port/build/int-20/bin \
  ./run.sh 1 400 10 > results.txt
```

Environment variables (all optional):

| variable | default | meaning |
|----------|---------|---------|
| `NEW` | `build/20-F005/bin` | bin dir of the clang under test (compiles and runs) |
| `BASE` | `build/int-20/bin` | bin dir of the comparison clang (assembly compared only) |
| `REF` | `host` | `host`: see below. `gap9gcc`: the old reference, for comparison only |
| `XCHECK` | `1` | with `REF=host`, also run the GAP9 GCC `-mnohwloop` cross-check |
| `NSETS` | `3` (`1` with `REF=gap9gcc`) | input sets (loop bounds) per seed, 1..3 |
| `OLEVELS` | `O2 O3 Os` | clang optimisation levels |
| `WD` | `w` | work root |
| `CLANG_EXTRA` | empty | extra flags for the clang kernel compiles |

`build/int-20` is rebuilt during the day; for a long run, copy its `bin/clang-20`,
`bin/lld` (+ `clang`, `ld.lld` symlinks) and `lib/clang/` to a scratch directory and
point `NEW`/`BASE` there.

## Status line

```
<seed> ref=[RES r h] refkind=host-gcc-O0+gap9gcc-O2-nohwloop sets=3 O2:<tag>:lp<n>:<ok> O3:... Os:... [flags]
```

* `ref=[...]` is the reference for input set 0.
* `<tag>`: `same` / `CHANGED` (NEW assembly vs BASE), `BASECRASH` (BASE failed to compile).
  `NEWFAIL(base=<rc>)` / `OBJFAIL`: the clang under test failed to compile.
* `lp<n>`: number of `lp.` instructions in NEW's assembly.
* `<ok>`: `OK`, or `MISMATCH[s<j>:nmk=n,m,k:got=...:ref=...,...]` listing every input set
  where the clang result differs from the reference (`got=none` = hang/timeout/no output).
  **Only a MISMATCH is a clang wrong result.**
* flags: `REFDISAGREE[s<j>:nmk=..:host=..:gap9nohwloop=..]` when the two references differ
  for an input set. This is not a clang finding; it means one of the references is wrong
  for that kernel and needs a look. `XCHECKFAIL[s<j>]`: GAP9 GCC failed to compile.
  `REFFAIL`: host gcc failed (the seed is skipped).

## The reference and why (backlog B101)

The reference is **host `gcc -O0`** (x86-64; the kernels are pure 32-bit unsigned
arithmetic, so the result is target independent), **cross-checked with GAP9 GCC
`-O2 -mnohwloop` on GVSoC**. The clang result is compared with host gcc -O0; if the two
references disagree, the seed gets a separate `REFDISAGREE` flag.

Until 2026-09-28 the reference was GAP9 GCC `-O2` with hardware loops. That compiler has
a hardware-loop bug: in about 0.2% of generated kernels its hardware-loop pass replaces a
loop count held in a register with the constant 1 (`lp.setupi x1,1,...`), so the loop
runs once. 7 of the 8 "clang wrong results" the fuzzer had reported were this GCC bug,
not clang (backlog B101, also B15/B70/B86). Reproducer:
`triage-2026-09-28/gcc-bug/gcc-hwloop-count-bug.c`; analysis:
`triage-2026-09-28/report.txt`. `REF=gap9gcc` keeps the old behaviour for comparison.

## Input sets

Each seed runs with `NSETS` sets of loop bounds (n, m, k):

* set 0: the historical set, `n = seed%7+1, m = (seed/7)%9+1, k = (seed/63)%5+1` (all >= 1);
* sets 1, 2: `x = seed*7919 + j*104729; n = x%8, m = (x/8)%10, k = (x/80)%6`, which include
  zero bounds.

One fixed input set per seed hid some wrong paths (seeds 938, 960 in the triage).
