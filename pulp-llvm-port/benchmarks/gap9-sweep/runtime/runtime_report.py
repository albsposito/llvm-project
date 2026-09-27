"""Writes runtime_report.md from runtime_results.json (called by run_runtime.py)."""
import collections, math, pathlib

WORKLOAD = {
    'k03_matmul_worker_i16': 'C[32x32] int32 = A[32x32] x B[32x32] int16, values in [-2048,2047]',
    'k05_matmul_dsp_fix16': 'Out[32x32] int16 = clip16(roundnorm(In1[32x32] x In2[32x32], 11)), values in [-4096,4095] (35/1024 outputs saturate int16, 283/1024 fall outside [-16384,16383])',
    'k06_matvect_dsp_f32': 'Out[64] = In2[64x256] x In1[256], fp32 in [-1,1)',
    'k09_cmplx_fix': '512 complex int16 -> re^2+im^2 (uint32)',
    'k11_dotprod_i8': '1024 int8 x int8 dot product (256 x v4s)',
    'clip': 'clip_s8 + clipu_u8 on 1024 ints in [-400,400], one call each per element',
    'k12_sum_loop': 'sum of 4096 uint32',
    'k12_copy_loop': 'd[i]=a[i]+7, 4096 uint32',
    'k12_dot8_loop': 'sdotsp4 over 1024 v4s',
    'k12_dot16_loop': 'sdotsp2 over 1024 v2s (int16 in [-2048,2047])',
    'k12_packed_add8_loop': 'v4u add over 1024 words',
    'k01_fir_fix16': 'KerFirSeq int16 FIR, 256 samples x 32 taps, Norm 12 (streaming delay line; KerFirSeqBaseline run once untimed, both outputs checksummed)',
    'k02_fir_f32': 'KerFirSeqf32 fp32 FIR, 256 samples x 32 taps, integer-valued samples/taps (SDK int accumulators; all arithmetic exact), baseline run once untimed',
    'k04_matmul_simple_f32': 'MatMulSimpleSeq fp32 Out[32x32] = M1[32x32] x M2[32x32] (non-transposed), values in [-1,1)',
    'k07_matadd_dsp_fix16': 'KerParMatAdd_DSP_Fix16 Out[32x32] int16 = clip16(roundnorm(In1+In2, 1)), full-range int16',
    'k08_preprocessing_fix': 'PreEmphasis (Q15 0.97, dynamic shift to Q13) + WindowingReal2Cmplx_Fix16 (400-point integer Welch window, zero-padded to 512 complex), 512 int16 samples',
    'k10a_fft_radix2_scalar': 'Radix2FFT_DIF_Scalar 256-point complex int16 FFT (SDK R2_Twiddles_fix_256), one fresh input copy per call',
}
# Kernels taken from the GAP9 SDK (DSP library / SDK examples); the rest were written for the sweep.
SDK_KERNELS = {'k01_fir_fix16', 'k02_fir_f32', 'k03_matmul_worker_i16', 'k04_matmul_simple_f32', 'k05_matmul_dsp_fix16',
               'k06_matvect_dsp_f32', 'k07_matadd_dsp_fix16', 'k08_preprocessing_fix', 'k09_cmplx_fix',
               'k10a_fft_radix2_scalar', 'k10b_fft_radix2_seq_fix16'}
CALL_LOOP = 'one call per element, 1024 random words (call-loop dominated)'


def fmt_ratio(x):
    return f'{x:.3f}'


def geomean(xs):
    return math.exp(sum(math.log(x) for x in xs) / len(xs)) if xs else None


def write(R, data):
    meta, rows, host = data['meta'], data['rows'], data['host']
    comps = list(meta['compilers'])
    extra = sorted({r['compiler'] for r in rows} - set(comps))     # +wa rows
    cols = comps + extra
    base, ref = meta['baseline'], meta['reference']
    llvm = [c for c in comps if c != ref]
    others = [c for c in llvm if c != base]
    t = {(r['kernel'], r['opt'], r['compiler']): r for r in rows}
    kernels, opts = meta['kernels'], meta['opts']
    good = lambda r: r is not None and r['status'] == 'ok'
    L = []
    w = L.append
    w('# GAP9 SDK kernel sweep: runtime (cycle counts on GVSoC)')
    w('')
    w('**Simulator caveat.** Numbers come from the GAP9 SDK\'s GVSoC2 `ri5ky_testbench` (one RI5CY/GAP9 core, '
      '1 MB zero-latency RAM), run in its slow timing mode. GVSoC is an instruction-accurate simulator with a timing '
      'model (pipeline stalls, hardware-loop and branch costs), **not** a cycle-exact model of GAP9 silicon: no '
      'caches/TCDM banking/cluster DMA are modelled and memory latency is 0. Treat ratios between builds as '
      'meaningful, absolute cycles as indicative.')
    w('')
    w('Per build: one warm-up call, then 4 timed calls; `cycles` = MMIO simulator cycles per call '
      '(`bench_cycles()` delta / 4), `instrs` = retired instructions per call (RI5CY PCCR instret, CSR 0x781). '
      'Runs are deterministic (repeat runs give identical counts). The timed region includes the call(s) and, for '
      'the per-element micro kernels, the driver\'s call loop.')
    w('')
    # ---------------- summary
    w('## Summary')
    w('')
    gm_lines = []
    for opt in opts:
        ks = [k for k in kernels if good(t.get((k, opt, base))) and all(good(t.get((k, opt, c))) for c in others)]
        for c in others + ([ref] if ref else []):
            xs = [t[(k, opt, c)]['cycles'] / t[(k, opt, base)]['cycles'] for k in ks if good(t.get((k, opt, c)))]
            core = [k for k in ks if k in WORKLOAD]
            xc = [t[(k, opt, c)]['cycles'] / t[(k, opt, base)]['cycles'] for k in core if good(t.get((k, opt, c)))]
            if xs:
                gm_lines.append((opt, c, geomean(xs), len(xs), geomean(xc), len(xc), ks, core))
    w(f'Geometric mean of cycle ratios vs **{base}**, over the kernels where every LLVM build '
      f'({", ".join(x for x in llvm)}) ran and produced the reference checksum (WRONG RESULT builds excluded):')
    w('')
    w('| opt | ratio | all such kernels | n | SDK/loop kernels only (no call-loop micro kernels) | n |')
    w('|---|---|---|---|---|---|')
    for opt, c, g, n, gc, nc, ks, core in gm_lines:
        w(f'| {opt} | {c}/{base} | **{fmt_ratio(g)}** | {n} | {fmt_ratio(gc) if gc else "-"} | {nc} |')
    w('')
    sets = {}
    for opt, c, g, n, gc, nc, ks, core in gm_lines:
        sets.setdefault(opt, ks)
    for opt, ks in sets.items():
        w(f'- {opt} geomean set ({len(ks)}): ' + ', '.join(ks))
    w('')
    # ---------------- per-compiler status counts and LLVM vs GCC geomeans
    def bucket(r):
        st = r['status']
        if st == 'ok': return 'ok'
        if st == 'WRONG RESULT': return 'wrong'
        if st in ('compile-fail', 'link-fail'): return 'compile-fail'
        if st == 'sim-fail': return 'hang/sim-fail'
        return st
    w('Per compiler, over all kernel x opt builds (' + str(len(kernels)) + ' kernels x ' + str(len(opts)) + ' opts): '
      'ok / wrong result / compile or link failure / hang or simulator failure:')
    w('')
    w('| compiler | ok | wrong | compile-fail | hang/sim-fail |')
    w('|---|---|---|---|---|')
    for c in cols:
        cnt = collections.Counter(bucket(r) for r in rows if r['compiler'] == c)
        w(f'| {c} | {cnt["ok"]} | {cnt["wrong"]} | {cnt["compile-fail"]} | {cnt["hang/sim-fail"]} |')
    w('')
    w(f'Geometric mean of cycle ratios vs **{ref}** (GAP9 GCC), per LLVM compiler, over the kernels where that '
      'compiler\'s build is correct at that opt level (so the kernel sets differ between compilers; n given). '
      '"SDK kernels" = kernels taken from the GAP9 SDK (k01-k10); "all" adds the kernels written for the sweep '
      '(k11, clip, k12 micro kernels).')
    w('')
    w(f'| opt | compiler | SDK kernels /{ref} | n | all correct kernels /{ref} | n |')
    w('|---|---|---|---|---|---|')
    for opt in opts:
        for c in llvm + extra:
            ok_ks = [k for k in kernels if good(t.get((k, opt, c))) and good(t.get((k, opt, ref)))]
            xa = [t[(k, opt, c)]['cycles'] / t[(k, opt, ref)]['cycles'] for k in ok_ks]
            xs = [t[(k, opt, c)]['cycles'] / t[(k, opt, ref)]['cycles'] for k in ok_ks if k in SDK_KERNELS]
            if xa:
                w(f'| {opt} | {c} | {fmt_ratio(geomean(xs)) if xs else "-"} | {len(xs)} | **{fmt_ratio(geomean(xa))}** | {len(xa)} |')
    w('')
    wrong = sorted({(r['kernel']) for r in rows if r['status'] == 'WRONG RESULT'})
    w(f'- WRONG RESULT (checksum differs from GAP9 GCC, confirmed by the host build): '
      + '; '.join(f'`{k}` on ' + ', '.join(sorted({r["compiler"] + " " + r["opt"] for r in rows
                                                     if r["kernel"] == k and r["status"] == "WRONG RESULT"}))
                   for k in wrong) + '. No speed number from these builds is used anywhere below.')
    for k in wrong:
        rr = next(r for r in rows if r['kernel'] == k and r['status'] == 'WRONG RESULT')
        if 'cause:' in rr.get('reason', ''):
            w(f'  - `{k}`: {rr["reason"].split("cause: ")[1]}')
    w('')
    # ---------------- setup
    w('## Setup')
    w('')
    for c, v in meta['compilers'].items():
        w(f'- **{c}**: `{v["path"]}` ({v["version"]})')
    w(f'- Kernel TU: compiled with exactly the static sweep command (`../run.py`: LLVM `{" ".join(meta["llvm_flags"])}`, '
      f'GCC `{" ".join(meta["gcc_flags"])}`, sweep shim + SDK includes, `-O2`/`-O3`). Every clang kernel object is '
      'byte-identical to the static sweep\'s object in `../build/` (checked by sha256, `kernel_obj_same_as_static_sweep`).')
    w(f'- Driver (`drivers/<kernel>.c`, helpers in `rt.h`) and `rt_libc.c` (memcpy/memset): same compiler, same flags and opt level, '
      f'plus `{" ".join(meta["driver_flags"][:2])}`. Runtime: `../sim/crt0.S`, `../sim/link.ld`, `../sim/bench.h`. '
      'LLVM builds link with that toolchain\'s `ld.lld` (+ GAP9 `libgcc.a` for 64-bit helpers), GCC builds with the GCC driver and `-lgcc`.')
    w('- Driver trip counts are read from volatile globals: port20 crashes on constant-trip-count hardware loops at object '
      'emission (`lp.setupi`, see `../sim/README.md`). Untimed driver helpers (PRNG fill, FNV-1a hash, printing) are '
      '`optnone` under clang because ref18/port19 crash in the "PULP Hardware Loops" pass on such simple loops; '
      'they run outside the timed region.')
    w(f'- Host reference: `{meta["host_cc"]}` `{" ".join(meta["host_flags"][:2])}`, same driver (`-DRT_HOST`) + the same kernel '
      'source, with `hostshim/at_api.h` defining `__EMUL__` (not `__pulp__`) so the SDK\'s `Emulation/GapBuiltins.h` '
      'uses its plain-C branch; the sweep\'s own TUs that call `__builtin_pulp_*` directly get the models in `hostshim/pulp_emul.h`.')
    w(f'- Simulator: {meta["simulator"]}; builds and simulations run in parallel (one thread per core).')
    w('')
    w('| kernel | workload | host reference semantics | host == GCC -O2 |')
    w('|---|---|---|---|')
    for k in kernels:
        h = host.get(k, {})
        g = t.get((k, 'O2', ref))
        if h.get('status') == 'ok' and good(g):
            same = 'yes' if h['checksum'] == g['checksum'] else (
                'no (fp32: ' + (f'max rel err {g.get("max_rel_err_vs_host", 0):.1e}' if g.get('max_rel_err_vs_host') is not None else 'differs')
                + '; x86 has no fused multiply-add, GCC/clang RISC-V builds fuse)')
        else:
            same = h.get('status', '-') + (': ' + h.get('reason', '') if h.get('reason') else '')
        w(f'| {k} | {WORKLOAD.get(k, CALL_LOOP)} | {h.get("semantics", "-")} | {same} |')
    w('')
    # ---------------- full table
    w('## Results: kernel x compiler x opt')
    w('')
    w('Cell: `status cycles / instrs` per call. `WRONG` = ran, checksum differs from the GCC reference (cycles shown for '
      'information only, never compared). compile-fail/link-fail/sim-fail give the reason below the table.')
    w('')
    w('| kernel | opt | ' + ' | '.join(cols) + ' |')
    w('|---|---|' + '---|' * len(cols))
    fails = collections.defaultdict(list)
    for k in kernels:
        for opt in opts:
            cells = []
            for c in cols:
                r = t.get((k, opt, c))
                if r is None:
                    cells.append('')
                elif r['status'] == 'ok':
                    cells.append(f'ok {r["cycles"]} / {r["instrs"]}')
                elif r['status'] == 'WRONG RESULT':
                    cells.append(f'**WRONG** ({r["cycles"]} / {r["instrs"]})')
                else:
                    short = r['reason'].split(':')[0] if r.get('reason') else ''
                    cells.append(f'{r["status"]}')
                    fails[f'{r["status"]}: {r.get("reason", "")}'].append(f'{k} {c} {opt}')
            w(f'| {k} | {opt} | ' + ' | '.join(cells) + ' |')
    w('')
    for why, where in sorted(fails.items()):
        w(f'- **{why.replace(str(R), ".")}** — ' + ', '.join(where))
    notes = sorted({(r['kernel'], n) for r in rows for n in r.get('notes', [])})
    for k, n in notes:
        w(f'- note {k}: {n}')
    w('')
    # ---------------- ratio table
    w(f'## Cycle ratios vs {base} (only where both builds ran and are correct)')
    w('')
    w(f'| kernel | opt | {base} cycles | ' + ' | '.join(f'{c}/{base}' for c in others + [ref]) + ' |')
    w('|---|---|---|' + '---|' * (len(others) + 1))
    for k in kernels:
        for opt in opts:
            b = t.get((k, opt, base))
            if not good(b):
                continue
            cells = []
            for c in others + [ref]:
                r = t.get((k, opt, c))
                cells.append(fmt_ratio(r['cycles'] / b['cycles']) if good(r) else (r['status'] if r else ''))
            w(f'| {k} | {opt} | {b["cycles"]} | ' + ' | '.join(cells) + ' |')
    w('')
    # ---------------- no-baseline kernels
    nob = [(k, opt) for k in kernels for opt in opts
           if not good(t.get((k, opt, base))) and any(good(t.get((k, opt, c))) for c in others)]
    if nob:
        w(f'## Kernels without a correct {base} baseline (compared with GCC only)')
        w('')
        w(f'| kernel | opt | {base} | ' + ' | '.join(f'{c} cycles' for c in others) + f' | {ref} cycles | ' +
          ' | '.join(f'{c}/{ref}' for c in others) + ' |')
        w('|---|---|---|' + '---|' * (2 * len(others) + 1))
        for k, opt in nob:
            b, g = t.get((k, opt, base)), t.get((k, opt, ref))
            cs = [t.get((k, opt, c)) for c in others]
            w(f'| {k} | {opt} | {b["status"] if b else ""} | ' + ' | '.join(str(r['cycles']) if good(r) else (r['status'] if r else '') for r in cs)
              + f' | {g["cycles"] if good(g) else ""} | ' +
              ' | '.join(fmt_ratio(r['cycles'] / g['cycles']) if good(r) and good(g) else '' for r in cs) + ' |')
        w('')
    # ---------------- analysis
    notes_md = pathlib.Path(R) / 'notes.md'
    if notes_md.exists():
        w(notes_md.read_text().rstrip())
        w('')
    w('## Reproduce')
    w('')
    w('`python3 run_runtime.py` (from any directory; about 10 s on 32 cores). It deletes and rebuilds `build/`, rewrites '
      '`runtime_results.json` and this report. Add a compiler without code changes: '
      '`python3 run_runtime.py --add port20fix=/path/to/bin/clang` (it becomes an extra column and ratio). '
      '`--compilers`, `--kernels` restrict the run; `--report-only` regenerates this file from the JSON. '
      'Per build: objects, `kernel.dis`, `build.log` (exact commands), `sim.log` in `build/<compiler>/<opt>/<kernel>/`. '
      '`pc_profile.py <elf> [function]` gives a per-PC execution profile from a GVSoC instruction trace '
      '(used for the regression analysis above). The analysis text comes from `notes.md`.')
    (pathlib.Path(R) / 'runtime_report.md').write_text('\n'.join(L) + '\n')
