#!/usr/bin/env python3
"""MFCC application benchmark: our clang vs GAP9 GCC, on the GVSoC ri5ky_testbench (one core).

  python3 run.py                 # tables, host reference, build + simulate everything, results.json
  python3 run.py --variants fix16,f32 --opts O2
  python3 run.py --no-sim        # build only
  python3 report.py              # report.md from results.json (+ analysis.txt)

Writes gen/ (tables), build/<config>/<compiler>/<opt>/ (objects, ELF, disassembly, logs) and
results.json. Nothing outside this directory is written (the simulator uses a temp dir).
"""
import argparse, concurrent.futures, json, math, pathlib, re, struct, subprocess, sys

R = pathlib.Path(__file__).resolve().parent
H = R.parent.parent.parent                                    # pulp-llvm-port/
SWEEP = H / 'benchmarks/gap9-sweep'
SIM, RT = SWEEP / 'sim', SWEEP / 'runtime'
SDK = pathlib.Path('/home/ubuntu/gap_sdk_release')
AT = SDK / 'tools/autotiler_v3'
DSP = AT / 'BasicKernels/DSP_Libraries'
LUT = DSP / 'TransformFunctions/LUT_Tables'
GCCROOT = pathlib.Path('/home/ubuntu/gap_riscv_toolchain_ubuntu')
TC = H / 'toolchains/port-20-bench/bin'
LIBGCC = GCCROOT / 'lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32/libgcc.a'
COMPILER_RT = H.parent / 'compiler-rt/lib/builtins'
VENV_PY = '/home/ubuntu/gvsoc-venv/bin/python'               # only for numpy (ref_mfcc.py)

COMPILERS = {'clang': TC / 'clang', 'gcc': GCCROOT / 'bin/riscv32-unknown-elf-gcc'}
CLANG_FLAGS = ['--target=riscv32-unknown-elf', '-march=rv32imc_xgap9', '-mPE=8', '-mabi=ilp32', '-mno-relax',
               '-isystem', str(GCCROOT / 'riscv32-unknown-elf/include')]
GCC_FLAGS = ['-march=rv32imcxgap9', '-mPE=8', '-mFC=1']
INCLUDES = ['-I' + str(p) for p in (R / 'shim', R / 'gen', DSP, DSP / 'FastMathFunctions', LUT, AT / 'Emulation', SIM, RT)] \
    + ['-D__GAP9__']
APP_FLAGS = ['-ffreestanding', '-fno-builtin']                # app + memcpy/memset only, as the gap9-sweep drivers
HOST_FLAGS = ['-O0', '-fwrapv', '-DRT_HOST', '-D__EMUL__', '-w', '-flax-vector-conversions',
              '-I' + str(R / 'hostshim'), '-I' + str(R / 'gen'), '-I' + str(DSP), '-I' + str(DSP / 'FastMathFunctions'),
              '-I' + str(LUT), '-I' + str(AT / 'Emulation'), '-I' + str(RT)]
OPTS = ['O2', 'O3', 'Os']
STAGES = ['preemph', 'window', 'rfft', 'spectrum', 'mel', 'log', 'dct']
ASSUMED_MHZ = 370          # the SDK Mfcc example sets FREQ_CL = FREQ_FC = 370 (CMakeLists.txt); an assumption here
OBJDUMP_MATTR = '--mattr=+m,+c,+zfinx,+xpulpv,+xgap'


def kern(sfx):
    return [DSP / 'WindowFunctions' / f'PreProcessing{sfx}.c', DSP / 'TransformFunctions' / f'FftLibrary{sfx}.c',
            DSP / 'ComplexMathFunctions' / f'CmplxFunctions{sfx}.c', DSP / 'TransformFunctions' / f'DctLibrary{sfx}.c']


def lutdefs(tag):
    return [f'-DGAP_R4_FFT_{tag}256'.replace('FFT_FIX16_', 'FFT_'), '-DGAP_R4_SWAP_TABLE_256', f'-DGAP_RFFT_{tag}512']


LUT_SRCS = [LUT / 'TwiddlesDef.c', LUT / 'SwapTablesDef.c', LUT / 'RFFTTwiddlesDef.c']
# config -> (variant, -D for the app, kernel sources, LUT selectors, extra link objects built from source, note)
CONFIGS = {
    'fix16': dict(variant='fix16', defs=['-DMFCC_FIX16'], kernels=kern('Fix') + [DSP / 'FastMathFunctions/MathFuncsFix.c'],
                  lut=lutdefs('FIX16_')),
    'f32': dict(variant='f32', defs=['-DMFCC_F32'],
                kernels=kern('f32') + [DSP / 'TransformFunctions/MfccLibraryf32.c', DSP / 'FastMathFunctions/PiecewiseMathf32.c'],
                lut=lutdefs('F32_')),
    'f16': dict(variant='f16', defs=['-DMFCC_F16'],
                kernels=kern('f16') + [DSP / 'TransformFunctions/MfccLibraryf16.c', DSP / 'FastMathFunctions/PiecewiseMathf16.c'],
                lut=lutdefs('F16_')),
    'f16a': dict(variant='f16a', defs=['-DMFCC_F16A'],
                 kernels=kern('f16a') + [DSP / 'TransformFunctions/MfccLibraryf16a.c', DSP / 'FastMathFunctions/PiecewiseMathf16a.c'],
                 lut=lutdefs('F16A_')),
}
# Labelled experiments (see report): the log stage through the SDK's Db_f16*_f32 kernels, and
# compiler-rt's __truncsfbf2 linked in for clang.
# 'gc': the timed ELF is linked from -ffunction-sections objects with --gc-sections (both compilers),
# so that the unused Db_f16/Db_f16a in the same SDK object (which clang cannot link) is dropped.
CONFIGS['f16+logf32'] = dict(CONFIGS['f16'], defs=['-DMFCC_F16', '-DMFCC_LOG_VIA_F32'], gc=True,
                             experiment='log stage = SDK Db_f16_f32; linked with --gc-sections')
CONFIGS['f16a+logf32'] = dict(CONFIGS['f16a'], defs=['-DMFCC_F16A', '-DMFCC_LOG_VIA_F32'], gc=True,
                              experiment='log stage = SDK Db_f16a_f32; linked with --gc-sections')
CONFIGS['f16a+logf32+rt'] = dict(CONFIGS['f16a+logf32'], rt=True,
                                 experiment="log stage = SDK Db_f16a_f32; linked with --gc-sections; "
                                            "clang also links compiler-rt's truncsfbf2.c (B133 workaround)")
# clang contracts a*b+c only inside one C expression (-ffp-contract=on); GCC 7 contracts across statements
# (-ffp-contract=fast). These experiments give clang GCC's setting, to test whether that explains the
# float differences.
CONFIGS['f32+contract'] = dict(CONFIGS['f32'], clang_extra=['-ffp-contract=fast'],
                               experiment='clang built with -ffp-contract=fast (GCC default behaviour); GCC unchanged')
CONFIGS['f16+logf32+contract'] = dict(CONFIGS['f16+logf32'], clang_extra=['-ffp-contract=fast'],
                                      experiment='log stage = SDK Db_f16_f32; linked with --gc-sections; '
                                                 'clang built with -ffp-contract=fast; GCC unchanged')
DEFAULT_CONFIGS = list(CONFIGS)


def sh(cmd, timeout=600, **kw):
    cmd = [str(c) for c in cmd]
    try:
        p = subprocess.run(cmd, text=True, capture_output=True, timeout=timeout, errors='replace', **kw)
    except subprocess.TimeoutExpired:
        p = subprocess.CompletedProcess(cmd, -999, '', f'TIMEOUT after {timeout}s')
    p.cmd = ' '.join(cmd)
    return p


def first_err(text):
    ls = [l.strip() for l in (text or '').splitlines() if re.search(r'error|undefined|Assertion|Stack dump|fatal|TIMEOUT', l)]
    seen, out = set(), []
    for l in ls:
        l = l.replace(str(SDK) + '/', '$SDK/').replace(str(H) + '/', '')
        if l not in seen:
            seen.add(l); out.append(l)
    return ' | '.join(out[:6]) or (text or '').strip()[-300:]


def build(config, cc, opt):
    cfg = CONFIGS[config]
    out = R / 'build' / config / cc / opt
    out.mkdir(parents=True, exist_ok=True)
    path = COMPILERS[cc]
    base = GCC_FLAGS if cc == 'gcc' else CLANG_FLAGS + cfg.get('clang_extra', [])
    row = dict(config=config, variant=cfg['variant'], compiler=cc, opt=opt, experiment=cfg.get('experiment'), notes=[])
    log = []
    srcs = [('crt0', SIM / 'crt0.S', []), ('app', R / 'src/mfcc_app.c', APP_FLAGS + cfg['defs'] + cfg['lut']),
            ('rt_libc', RT / 'rt_libc.c', APP_FLAGS)]
    srcs += [(s.stem, s, []) for s in cfg['kernels']] + [(s.stem, s, cfg['lut']) for s in LUT_SRCS]
    if cfg.get('rt') and cc == 'clang':
        srcs.append(('truncsfbf2', COMPILER_RT / 'truncsfbf2.c', ['-I' + str(COMPILER_RT)]))
    objs = {'plain': [], 'fs': []}
    for tag, src, extra in srcs:
        for kind, kflags in (('plain', []), ('fs', ['-ffunction-sections', '-fdata-sections'])):
            o = out / f'{tag}.{kind}.o'
            p = sh([path, *base, *INCLUDES, '-' + opt, *extra, *kflags, '-c', src, '-o', o])
            log.append(f'$ {p.cmd}\n[rc={p.returncode}]\n{p.stderr}')
            if p.returncode != 0:
                (out / 'build.log').write_text('\n'.join(log))
                row.update(status='compile-fail', reason=f'{tag}: ' + first_err(p.stderr), failed_cmd=p.cmd)
                return row
            objs[kind].append(o)
    for name, kind, extra in (('prog.elf', 'fs' if cfg.get('gc') else 'plain', ['--gc-sections'] if cfg.get('gc') else []),
                              ('prog.gc.elf', 'fs', ['--gc-sections'])):
        elf = out / name
        if cc == 'gcc':
            cmd = [path, *base, '-nostdlib', '-static', '-T', SIM / 'link.ld', *objs[kind], '-lgcc',
                   *['-Wl,' + e for e in extra], '-o', elf]
        else:
            cmd = [TC / 'ld.lld', '-nostdlib', '-static', '-T', SIM / 'link.ld', *objs[kind], LIBGCC, *extra, '-o', elf]
        p = sh(cmd)
        log.append(f'$ {p.cmd}\n[rc={p.returncode}]\n{p.stderr}')
        if p.returncode != 0:
            (out / 'build.log').write_text('\n'.join(log))
            undef = sorted(set(re.findall(r"undefined (?:symbol: |reference to `)([A-Za-z0-9_]+)", p.stderr)))
            if name == 'prog.elf':
                row.update(status='link-fail', reason=first_err(p.stderr), undefined=undef, failed_cmd=p.cmd)
                return row
            row['notes'].append('gc link failed: ' + first_err(p.stderr))
    (out / 'build.log').write_text('\n'.join(log))
    (out / 'prog.dis').write_text(sh([TC / 'llvm-objdump', '-d', OBJDUMP_MATTR, out / 'prog.elf']).stdout)
    # sizes: whole .text of the timed ELF, .text after dead-function removal, per-function sizes (gc ELF)
    row['text_bytes_all'] = section_size(out / 'prog.elf', '.text')
    if not (out / 'prog.gc.elf').exists():
        row.update(status='link-fail', reason=row['notes'][-1]); return row
    row['text_bytes'] = section_size(out / 'prog.gc.elf', '.text')
    row['rodata_bytes'] = section_size(out / 'prog.gc.elf', '.rodata')
    row['functions'] = func_sizes(out / 'prog.gc.elf')
    row.update(status='built', elf=str((out / 'prog.elf').relative_to(R)))
    return row


def section_size(elf, name):
    for l in sh([TC / 'llvm-size', '-A', elf]).stdout.splitlines():
        f = l.split()
        if len(f) >= 2 and f[0] == name:
            return int(f[1])
    return None


def func_sizes(elf):
    d = {}
    for l in sh([TC / 'llvm-nm', '-S', '--defined-only', elf]).stdout.splitlines():
        f = l.split()
        if len(f) == 4 and f[2] in 'tT':
            d[f[3]] = int(f[1], 16)
    return d


TOTAL = re.compile(r'^TOTAL variant=(\S+) frames=(\d+) stage_cycles=(\d+) stage_instrs=(\d+) checksum=(0x[0-9a-f]+)', re.M)
STAGE = re.compile(r'^STAGE name=(\S+) cycles=(\d+) instrs=(\d+) hash=(0x[0-9a-f]+)', re.M)
MFCC = re.compile(r'^MFCC (\d+)((?: 0x[0-9a-f]{8})+)\s*$', re.M)


def parse(text):
    m = TOTAL.search(text)
    if not m:
        return None
    frames = int(m.group(2))
    res = dict(frames=frames, total_cycles=int(m.group(3)), total_instrs=int(m.group(4)), checksum=m.group(5),
               cycles_per_frame=int(m.group(3)) / frames, instrs_per_frame=int(m.group(4)) / frames, stages={})
    for n, c, i, h in STAGE.findall(text):
        res['stages'][n] = dict(cycles=int(c), instrs=int(i), hash=h, cycles_per_frame=int(c) / frames, instrs_per_frame=int(i) / frames)
    res['mfcc_raw'] = [[int(x, 16) for x in vals.split()] for _, vals in MFCC.findall(text)]
    return res


def simulate(row):
    if row['status'] != 'built':
        return row
    elf = R / row['elf']
    p = sh([SIM / 'run_sim.sh', elf], timeout=3000)
    (elf.parent / 'sim.log').write_text(p.stdout + p.stderr)
    res = parse(p.stdout)
    if p.returncode != 0 or res is None:
        tail = [l for l in (p.stdout + p.stderr).splitlines() if l.strip() and not l.startswith('MFCC')][-3:]
        row.update(status='sim-fail', reason=f'rc={p.returncode}; ' + ' | '.join(tail))
        return row
    row.update(status='ran', **res)
    return row


def host_ref(variant):
    out = R / 'build/host' / variant
    out.mkdir(parents=True, exist_ok=True)
    cfg = CONFIGS[variant]
    ks = list(cfg['kernels'])
    if cfg['variant'] in ('f16', 'f16a'):      # host emulation fix for Cvt_v2u_v2h, see hostshim/PiecewiseMath_host.c
        ks = [k for k in ks if 'PiecewiseMath' not in k.name] + [R / 'hostshim/PiecewiseMath_host.c']
    exe = out / 'prog'
    p = sh(['gcc', *HOST_FLAGS, *cfg['defs'], *cfg['lut'], R / 'src/mfcc_app.c', *ks, *LUT_SRCS, '-lm', '-o', exe])
    (out / 'build.stderr').write_text(p.stderr)
    if p.returncode != 0:
        return dict(status='compile-fail', reason=first_err(p.stderr))
    q = sh([exe])
    (out / 'run.log').write_text(q.stdout)
    res = parse(q.stdout)
    if res is None:
        return dict(status='run-fail', reason=q.stderr[-300:])
    return dict(status='ok', checksum=res['checksum'], mfcc_raw=res['mfcc_raw'],
                stage_hashes={k: v['hash'] for k, v in res['stages'].items()})


# ---- decoding and comparison (pure Python) ----
def decode(variant, u):
    if variant == 'fix16':
        return struct.unpack('<h', struct.pack('<H', u & 0xffff))[0] / 32.0      # Q5 dB
    if variant == 'f32':
        return struct.unpack('<f', struct.pack('<I', u))[0]
    if variant == 'f16':
        return struct.unpack('<e', struct.pack('<H', u & 0xffff))[0]
    return struct.unpack('<f', struct.pack('<I', (u & 0xffff) << 16))[0]          # bfloat16


def flat(variant, raw):
    return [decode(variant, u) for fr in raw for u in fr]


def compare(a, b):
    """a against reference b: SNR (dB), Pearson correlation, max abs difference, counts."""
    n = len(a)
    bad = sum(1 for x in a + b if not math.isfinite(x))
    if n != len(b) or n == 0:
        return dict(n=n, error='length mismatch')
    if bad:
        pairs = [(x, y) for x, y in zip(a, b) if math.isfinite(x) and math.isfinite(y)]
        a, b = [p[0] for p in pairs], [p[1] for p in pairs]
    if not a:
        return dict(n=n, nonfinite=bad, error='no finite values')
    err = sum((x - y) ** 2 for x, y in zip(a, b))
    sig = sum(y * y for y in b)
    ma, mb = sum(a) / len(a), sum(b) / len(b)
    va, vb = sum((x - ma) ** 2 for x in a), sum((y - mb) ** 2 for y in b)
    cov = sum((x - ma) * (y - mb) for x, y in zip(a, b))
    return dict(n=n, nonfinite=bad, differing=sum(1 for x, y in zip(a, b) if x != y),
                snr_db=round(10 * math.log10(sig / err), 2) if err > 0 else None,
                corr=round(cov / math.sqrt(va * vb), 6) if va > 0 and vb > 0 else None,
                max_abs_diff=max(abs(x - y) for x, y in zip(a, b)))


def judge(rows, hosts, ref):
    refrow = {r['config']: r for r in rows if r['compiler'] == 'gcc' and r['opt'] == 'O2' and r['status'] == 'ran'}
    for r in rows:
        if r['status'] != 'ran':
            continue
        v = r['variant']
        mine = flat(v, r['mfcc_raw'])
        g = refrow.get(r['config'])
        if g:
            r['bit_exact_vs_gcc_O2'] = r['mfcc_raw'] == g['mfcc_raw']
            r['vs_gcc_O2'] = compare(mine, flat(v, g['mfcc_raw']))
            r['first_diverging_stage_vs_gcc_O2'] = next((s for s in STAGES if r['stages'][s]['hash'] != g['stages'][s]['hash']), None)
        h = hosts.get(v)
        if h and h['status'] == 'ok' and 'logf32' not in r['config']:     # the host build uses the Db_f16 path
            r['bit_exact_vs_host'] = r['mfcc_raw'] == h['mfcc_raw']
            r['vs_host'] = compare(mine, flat(v, h['mfcc_raw']))
            r['first_diverging_stage_vs_host'] = next((s for s in STAGES if r['stages'][s]['hash'] != h['stage_hashes'][s]), None)
        if ref:
            r['vs_numpy_ref'] = compare(mine, [x for fr in ref for x in fr])
        # real-time headroom
        cps = r['cycles_per_frame'] * 16000 / 160
        r['cycles_per_second_of_audio'] = cps
        r['core_fraction_at_assumed_mhz'] = cps / (ASSUMED_MHZ * 1e6)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--variants', default=','.join(DEFAULT_CONFIGS), help='configs: ' + ','.join(CONFIGS))
    ap.add_argument('--compilers', default='clang,gcc')
    ap.add_argument('--opts', default=','.join(OPTS))
    ap.add_argument('--jobs', type=int, default=8)
    ap.add_argument('--no-sim', action='store_true')
    a = ap.parse_args()
    configs, ccs, opts = a.variants.split(','), a.compilers.split(','), a.opts.split(',')

    p = sh([sys.executable, R / 'gen_tables.py'])
    print(p.stdout.strip() or p.stderr)
    variants = sorted({CONFIGS[c]['variant'] for c in configs})
    hosts = {v: host_ref(v) for v in variants}
    for v, h in hosts.items():
        print(f'host {v}: {h["status"]} {h.get("checksum", h.get("reason", ""))}')
    p = sh([VENV_PY, R / 'ref_mfcc.py'])
    ref = json.loads(p.stdout) if p.returncode == 0 else None
    print('numpy reference:', 'ok' if ref else 'unavailable: ' + p.stderr[-200:])
    host_vs_ref = {v: compare(flat(v, h['mfcc_raw']), [x for fr in ref for x in fr]) for v, h in hosts.items()
                   if ref and h['status'] == 'ok'}

    jobs = [(c, cc, o) for c in configs for cc in ccs for o in opts
            if not (CONFIGS[c].get('rt') and cc == 'gcc')]
    with concurrent.futures.ThreadPoolExecutor(a.jobs) as ex:
        rows = list(ex.map(lambda j: build(*j), jobs))
        for r in rows:
            if r['status'] != 'built':
                print(f'{r["config"]:16s} {r["compiler"]:5s} {r["opt"]}: {r["status"]}: {r["reason"][:300]}')
        if not a.no_sim:
            rows = list(ex.map(simulate, rows))
    judge(rows, hosts, ref)
    for r in rows:
        if r['status'] == 'ran':
            print(f'{r["config"]:16s} {r["compiler"]:5s} {r["opt"]}: {r["cycles_per_frame"]:10.0f} cyc/frame '
                  f'{r["instrs_per_frame"]:10.0f} instr/frame  text {r["text_bytes"]:6d}  cks {r["checksum"]} '
                  f'exact_vs_gccO2={r.get("bit_exact_vs_gcc_O2")} exact_vs_host={r.get("bit_exact_vs_host")} '
                  f'snr_ref={r.get("vs_numpy_ref", {}).get("snr_db")}')
        elif r['status'] == 'sim-fail':
            print(f'{r["config"]:16s} {r["compiler"]:5s} {r["opt"]}: sim-fail: {r["reason"][:300]}')
    meta = dict(
        clang=sh([COMPILERS['clang'], '--version']).stdout.splitlines()[0],
        clang_snapshot=(H / 'toolchains/port-20-bench/SOURCE').read_text().strip(),
        gcc=sh([COMPILERS['gcc'], '--version']).stdout.splitlines()[0],
        clang_flags=CLANG_FLAGS, gcc_flags=GCC_FLAGS, includes=INCLUDES, app_flags=APP_FLAGS, host_flags=HOST_FLAGS,
        simulator='GVSoC2 ri5ky_testbench (one RI5CY core), benchmarks/gap9-sweep/sim/run_sim.sh',
        params=dict(sample_rate=16000, frame=512, hop=160, n_fft=512, window='hann (periodic)', n_mels=40, n_mfcc=13,
                    preemphasis=0.97, power=2, log='10*log10, clip 1e-10 (1e-7 for float16)', dct='type II, ortho',
                    wav=str(SDK / 'examples/gap9/dsp/samples/yes.wav')),
        assumed_mhz=ASSUMED_MHZ, stages=STAGES,
        headroom_formula='cycles_per_second_of_audio = cycles_per_frame * 16000 / 160; '
                         'core_fraction = cycles_per_second_of_audio / (MHz * 1e6)',
        hosts={v: {k: x for k, x in h.items() if k != 'mfcc_raw'} for v, h in hosts.items()},
        host_vs_numpy_ref=host_vs_ref,
        numpy_ref_available=bool(ref))
    (R / 'results.json').write_text(json.dumps(dict(meta=meta, rows=rows), indent=1))
    print('wrote results.json')


if __name__ == '__main__':
    main()
