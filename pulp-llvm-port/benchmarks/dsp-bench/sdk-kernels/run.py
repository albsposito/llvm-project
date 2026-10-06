#!/usr/bin/env python3
"""dsp-bench/sdk-kernels: the GAP9 SDK's DSP benchmark kernels, our clang vs GAP9 GCC.

Builds the DSP library files used by the six SDK benchmark apps
(examples/gap9/dsp/benchmarks: Fir, DftSimple, FFTL1, RFFTL1, IRFFTL1, MatMul) with
  clang  toolchains/port-20-bench/bin/clang  (-march=rv32imc_xgap9 -mPE=8)
  gcc    GAP9 GCC 7.1.1                      (-march=rv32imcxgap9 -mPE=8 -mFC=1)
at -O2, -O3 and -Os, links each with a small driver (drivers/*.c) and runs it on one GAP9
core of the GVSoC2 ri5ky_testbench (../../gap9-sweep/sim/run_sim.sh). Every result is
compared with the GCC build and with a host gcc -O0 build of the same sources.

  python3 run.py                 # everything: data, build, simulate, results.json, report.txt
  python3 run.py --progs fir_f32,fft_fix16 --opts O2
  python3 run.py --report-only   # rebuild report.txt from results.json

Nothing outside this directory is written (the simulator uses a temp work dir). The SDK is
read only. See report.txt for what is measured and for the caveats.
"""
import argparse, collections, concurrent.futures, json, math, os, pathlib, re, shutil, struct, subprocess, sys

R = pathlib.Path(__file__).resolve().parent
H = R.parent.parent.parent                                  # pulp-llvm-port/
SWEEP = H / 'benchmarks/gap9-sweep'
SIM, RT = SWEEP / 'sim', SWEEP / 'runtime'
SDK = pathlib.Path('/home/ubuntu/gap_sdk_release')
AT = SDK / 'tools/autotiler_v3'
DSP = AT / 'BasicKernels/DSP_Libraries'
APPS = SDK / 'examples/gap9/dsp/benchmarks'
GCCROOT = pathlib.Path('/home/ubuntu/gap_riscv_toolchain_ubuntu')
TC = H / 'toolchains/port-20-bench/bin'
LLVM_SRC = H.parent                                         # llvm-project/ (compiler-rt source for the B133 experiment)
PY_NUMPY = '/home/ubuntu/gvsoc-venv/bin/python3'            # a python with numpy (gen_test_data.py)
BUILD, GEN = R / 'build', R / 'gen'

COMPILERS = {'clang': TC / 'clang', 'gcc': GCCROOT / 'bin/riscv32-unknown-elf-gcc',
             # labelled experiment, in no headline number: the same clang with its own default -ffp-contract=on
             'clang-fpon': TC / 'clang'}
OPTS = ['O2', 'O3', 'Os']
# Our clang: the target flags of the M3 SDK compile survey (mode P) + what the SDK flag wrapper
# (benchmarks/sdk-clang/bin/riscv32-unknown-elf-clang) adds for code generation: GCC's
# -ffp-contract=fast default (owner decision D6/Q5).
CLANG_FLAGS = ['--target=riscv32-unknown-elf', '-march=rv32imc_xgap9', '-mPE=8', '-mabi=ilp32', '-mno-relax',
               '-isystem', str(GCCROOT / 'riscv32-unknown-elf/include'), '-ffp-contract=fast']
GCC_FLAGS = ['-march=rv32imcxgap9', '-mPE=8', '-mFC=1']
# The SDK's code-generation flags (utils/cmake/gcc_flags.cmake), minus -Os (the opt level is swept)
# and the warning flags. -fno-tree-loop-distribute-patterns is GCC only (the wrapper drops it for clang).
SDK_CFLAGS = ['-std=gnu99', '-fcommon', '-fno-jump-tables', '-fno-delete-null-pointer-checks', '-fomit-frame-pointer',
              '-ffunction-sections', '-fdata-sections', '-funsigned-char', '-w']
GCC_ONLY = ['-fno-tree-loop-distribute-patterns']
INC = ['-I' + str(R / 'shim'), '-I' + str(DSP), '-I' + str(DSP / 'FastMathFunctions'),
       '-I' + str(DSP / 'TransformFunctions/LUT_Tables'), '-I' + str(AT / 'Emulation'), '-D__GAP9__']
RT_REPS = 3
DRV_FLAGS = ['-ffreestanding', '-fno-builtin', f'-DRT_REPS={RT_REPS}', '-I' + str(R / 'drivers'), '-I' + str(RT),
             '-I' + str(SIM), '-I' + str(R / 'shim_common')]
HOST_CC = 'gcc'
HOST_FLAGS = ['-O0', '-fwrapv', '-w', '-flax-vector-conversions', '-DRT_HOST', '-D__EMUL__', f'-DRT_REPS={RT_REPS}', '-I' + str(R / 'hostshim'),
              '-I' + str(DSP), '-I' + str(DSP / 'FastMathFunctions'), '-I' + str(DSP / 'TransformFunctions/LUT_Tables'),
              '-I' + str(AT / 'Emulation'), '-I' + str(R / 'drivers'), '-I' + str(RT), '-I' + str(R / 'shim_common'),
              '-D__GAP9__']
MATTR = '--mattr=+m,+c,+zfinx,+zhinx,+xgap,+xpulpv,+xpulpf16alt,+xpulpfvec'
OBJDUMP, NM = TC / 'llvm-objdump', TC / 'llvm-nm'
SIM_TIMEOUT, CC_TIMEOUT = 3600, 900

LIBS = {  # DSP library translation units, compiled whole and unmodified
    'fir_fix16': DSP / 'FilteringFunctions/FirBasicKernelsFix.c', 'fir_f32': DSP / 'FilteringFunctions/FirBasicKernelsf32.c',
    'fir_f16': DSP / 'FilteringFunctions/FirBasicKernelsf16.c', 'fir_f16a': DSP / 'FilteringFunctions/FirBasicKernelsf16a.c',
    'fft_fix16': DSP / 'TransformFunctions/FftLibraryFix.c', 'fft_f32': DSP / 'TransformFunctions/FftLibraryf32.c',
    'fft_f16': DSP / 'TransformFunctions/FftLibraryf16.c', 'fft_f16a': DSP / 'TransformFunctions/FftLibraryf16a.c',
    'dft_f32': DSP / 'TransformFunctions/DftLibraryf32.c', 'dft_f16': DSP / 'TransformFunctions/DftLibraryf16.c',
    'dft_f16a': DSP / 'TransformFunctions/DftLibraryf16a.c', 'matmul': DSP / 'MatrixFunctions/MatMulDSP.c',
}
TABLES = {'twid': DSP / 'TransformFunctions/LUT_Tables/TwiddlesDef.c', 'rtwid': DSP / 'TransformFunctions/LUT_Tables/RFFTTwiddlesDef.c',
          'swap': DSP / 'TransformFunctions/LUT_Tables/SwapTablesDef.c'}
TABLE_DEFS = ['-DGAP_ALL_FFT_TABLES', '-DGAP_ALL_SWAP_TABLES', '-DGAP_ALL_RFFT_TABLES']
# memcpy/memset: gap9-sweep's rt_libc.c, plain byte loops, the same code as the SDK's own libc
# (rtos/pmsis/os/freeRTOS/vendors/gwt/libs/src/string.c), built by the compiler under test.
MEMLIB = RT / 'rt_libc.c'
DTS = ['fix16', 'f32', 'f16', 'f16a']
FLOAT_C = {'f32': 'float', 'f16': 'float16', 'f16a': 'float16alt'}
# Tolerance for float outputs that are not bit-exact: max |a-b| over the output, divided by the
# largest |reference| value (the DftSimple app's own check_output() metric).
TOL = {'f32': 1e-4, 'f16': 2e-2, 'f16a': 2e-2}


def progs():
    """One program = one driver build = one app x data type. category: 'app' = a configuration the
    benchmark app itself runs or can be Kconfig'd to run; 'lib-variant' = same library, same driver,
    but a data type the app cannot select (f16alt everywhere, MatMul fix16/f16)."""
    P = []
    for i, dt in enumerate(DTS):
        cat = 'lib-variant' if dt == 'f16a' else 'app'
        P.append(dict(id=f'fir_{dt}', app='Fir', dt=dt, driver='fir.c', defs=[f'-DDT={i}'], libs=[f'fir_{dt}'], tables=False,
                      gen=None, extra=[], nk=3, category=cat))
        P.append(dict(id=f'fft_{dt}', app='FFTL1', dt=dt, driver='fft.c', defs=[f'-DDT={i}'], libs=sorted({'fft_fix16', f'fft_{dt}'}),
                      tables=True, gen='fftl1', extra=[], nk=2, category=cat))
        P.append(dict(id=f'rfft_{dt}', app='RFFTL1', dt=dt, driver='rfft.c', defs=[f'-DDT={i}'], libs=sorted({'fft_fix16', f'fft_{dt}'}),
                      tables=True, gen='rfftl1', extra=[], nk=2, category=cat))
        P.append(dict(id=f'irfft_{dt}', app='IRFFTL1', dt=dt, driver='rfft.c', defs=[f'-DDT={i}', '-DAPP_IRFFT'],
                      libs=sorted({'fft_fix16', f'fft_{dt}'}), tables=True, gen='irfftl1', extra=[], nk=2, category=cat))
        if dt != 'fix16':
            for kind in ['real', 'cplx']:
                g = f'dft_{kind}_{FLOAT_C[dt]}'
                P.append(dict(id=f'dft_{kind}_{dt}', app='DftSimple', dt=dt, driver='dft.c', defs=[f'-DDT={i}'], libs=[f'dft_{dt}'],
                              tables=False, gen=g, extra=[GEN / g / 'TestData.c'], nk=2, category=cat))
        P.append(dict(id=f'matmul_{dt}', app='MatMul', dt=dt, driver='matmul.c', defs=[f'-DDT={i}'], libs=['matmul'], tables=False,
                      gen=None, extra=[], nk=2, category='app' if dt == 'f32' else 'lib-variant'))
    return P


def sh(cmd, timeout=CC_TIMEOUT, **kw):
    cmd = [str(c) for c in cmd]
    try:
        p = subprocess.run(cmd, text=True, capture_output=True, timeout=timeout, **kw)
    except subprocess.TimeoutExpired:
        p = subprocess.CompletedProcess(cmd, -999, '', f'TIMEOUT after {timeout}s')
    p.cmd = ' '.join(cmd)
    return p


# ---------------------------------------------------------------- input data (the apps' own generators)
def gen_data():
    GEN.mkdir(exist_ok=True)
    log = []
    hinc = ['-I.', '-I' + str(SDK / 'libs/include'), '-I' + str(AT / 'Emulation')]
    for name, app, defs in [('fftl1', 'FFTL1', ['-DMAXDIM=2048', '-DPAD=0']),
                            ('rfftl1', 'RFFTL1', ['-DMAXDIM=4096', '-DNFRAMES=1', '-DPAD=0']),
                            ('irfftl1', 'IRFFTL1', ['-DMAXDIM=2048', '-DPAD=0'])]:
        d = GEN / name
        d.mkdir(exist_ok=True)
        # the app's own CMake command: gcc -o GenInData InitData.c ... -DGENERATE_FILES -DMAXDIM=.. -DPAD=.. && ./GenInData
        p = sh([HOST_CC, '-o', 'GenInData', APPS / app / 'InitData.c', *hinc, '-lm', '-DGENERATE_FILES', *defs], cwd=d)
        assert p.returncode == 0, p.stderr
        q = sh(['./GenInData'], cwd=d)
        assert q.returncode == 0 and (d / 'In_Data.h').exists(), q.stderr
        log.append(p.cmd)
    stubs = BUILD / 'pystubs'       # gen_test_data.py imports scipy/matplotlib only for --plot, which is not used
    (stubs / 'scipy').mkdir(parents=True, exist_ok=True)
    (stubs / 'scipy/__init__.py').write_text('')
    (stubs / 'scipy/signal.py').write_text('')
    for kind in ['real', 'cplx']:
        for dt, ct in FLOAT_C.items():
            d = GEN / f'dft_{kind}_{ct}'
            env = dict(os.environ, PYTHONPATH=str(stubs), MPLBACKEND='Agg', MPLCONFIGDIR=str(BUILD / 'mpl'))
            p = sh([PY_NUMPY, APPS / 'DftSimple/gen_test_data.py', f'--dft_type={kind}', '--frame_size=400', f'--outdir={d}',
                    f'--float_type={ct}'], env=env, cwd=BUILD)
            assert p.returncode == 0 and (d / 'TestData.c').exists(), p.stderr
            log.append(p.cmd)
    (GEN / 'commands.txt').write_text('\n'.join(log) + '\n')


# ---------------------------------------------------------------- target builds
def cc_base(cc):
    if cc == 'gcc':
        return [COMPILERS[cc], *GCC_FLAGS, *GCC_ONLY, *SDK_CFLAGS]
    flags = [f for f in CLANG_FLAGS if cc == 'clang' or f != '-ffp-contract=fast']
    return [COMPILERS[cc], *flags, *SDK_CFLAGS]


def compile_one(cc, opt, src, obj, extra):
    obj.parent.mkdir(parents=True, exist_ok=True)
    p = sh([*cc_base(cc), '-' + opt, *extra, '-c', src, '-o', obj])
    (obj.parent / (obj.name + '.log')).write_text(f'$ {p.cmd}\n[rc={p.returncode}]\n{p.stderr}')
    return p


def build_common(cc, opt):
    """Library objects, tables, crt0, memcpy/memset for one compiler and opt level."""
    out = BUILD / cc / opt
    res = {}
    jobs = [(n, s, out / 'lib' / f'{n}.o', INC) for n, s in LIBS.items()]
    jobs += [(n, s, out / 'lib' / f'{n}.o', INC + TABLE_DEFS) for n, s in TABLES.items()]
    jobs += [('crt0', SIM / 'crt0.S', out / 'lib/crt0.o', []),
             ('string', MEMLIB, out / 'lib/string.o', ['-ffreestanding', '-fno-builtin'])]
    if cc != 'gcc':     # separate, labelled experiment only (B133): compiler-rt's bfloat16 truncation helper
        jobs.append(('truncsfbf2', LLVM_SRC / 'compiler-rt/lib/builtins/truncsfbf2.c', out / 'lib/truncsfbf2.o', []))
    for n, s, o, extra in jobs:
        p = compile_one(cc, opt, s, o, extra)
        res[n] = dict(obj=str(o), rc=p.returncode, err=p.stderr[-2000:] if p.returncode else '')
        if p.returncode == 0 and n in LIBS:
            (o.parent / f'{n}.dis').write_text(sh([OBJDUMP, '-d', '-r', MATTR, o]).stdout)
    return res


def link(cc, objs, elf, extra_objs=()):
    libgcc = GCCROOT / 'lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32/libgcc.a'
    if cc == 'gcc':
        cmd = [COMPILERS[cc], *GCC_FLAGS, '-nostdlib', '-static', '-Wl,--gc-sections', '-T', SIM / 'link.ld', *objs, '-lgcc', '-o', elf]
    else:
        cmd = [TC / 'ld.lld', '-nostdlib', '-static', '--gc-sections', '-T', SIM / 'link.ld', *objs, *extra_objs, libgcc, '-o', elf]
    return sh(cmd)


def build_prog(prog, cc, opt, common):
    """Returns a list of ELF records: dict(compiler label, ksel, elf|None, status, reason)."""
    out = BUILD / cc / opt / prog['id']
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True)
    recs = []
    bad = [n for n in prog['libs'] + ['crt0', 'string'] + (list(TABLES) if prog['tables'] else []) if common[n]['rc'] != 0]
    if bad:
        return [dict(compiler=cc, ksel=-1, elf=None, status='compile-fail', reason=f'{bad[0]}: ' + common[bad[0]]['err'][-400:])]
    inc = INC + DRV_FLAGS + prog['defs'] + (['-I' + str(GEN / prog['gen'])] if prog['gen'] else [])
    extra_objs = []
    for s in prog['extra']:
        o = out / (pathlib.Path(s).stem + '.o')
        p = compile_one(cc, opt, s, o, inc)
        if p.returncode != 0:
            return [dict(compiler=cc, ksel=-1, elf=None, status='compile-fail', reason=f'{pathlib.Path(s).name}: ' + p.stderr[-400:])]
        extra_objs.append(o)
    libobjs = [common[n]['obj'] for n in ['crt0'] + prog['libs'] + ['string'] + (list(TABLES) if prog['tables'] else [])]

    def drv(ksel):
        o = out / (f'driver{"" if ksel < 0 else "_k%d" % ksel}.o')
        p = compile_one(cc, opt, R / 'drivers' / prog['driver'], o, inc + ([f'-DKSEL={ksel}'] if ksel >= 0 else []))
        return o, p

    o, p = drv(-1)
    if p.returncode != 0:
        return [dict(compiler=cc, ksel=-1, elf=None, status='compile-fail', reason='driver: ' + p.stderr[-600:])]
    elf = out / 'prog.elf'
    p = link(cc, [o, *extra_objs, *libobjs], elf)
    (out / 'link.log').write_text(f'$ {p.cmd}\n[rc={p.returncode}]\n{p.stderr}')
    if p.returncode == 0:
        return [dict(compiler=cc, ksel=-1, elf=str(elf), status='built', reason='')]
    und = sorted(set(re.findall(r'undefined (?:symbol|reference to)[:`\' ]+([A-Za-z_0-9]+)', p.stderr)))
    refby = sorted(set(re.findall(r'>>>\s+\S+\.o:\(([A-Za-z_0-9.]+)\)', p.stderr)))
    why = f'undefined {", ".join(und)}; referenced by {", ".join(refby)[:300]}'
    if cc == 'gcc' or und != ['__truncsfbf2']:
        return [dict(compiler=cc, ksel=-1, elf=None, status='link-fail', reason=why + ' | ' + p.stderr[-300:])]
    # B133: bfloat16 code needs __truncsfbf2, which GAP9 libgcc lacks. Find out which kernels still link
    # (one ELF per kernel group), and build the separately labelled compiler-rt experiment.
    for k in range(prog['nk']):
        o2, p2 = drv(k)
        elfk = out / f'prog_k{k}.elf'
        p3 = link(cc, [o2, *extra_objs, *libobjs], elfk) if p2.returncode == 0 else p2
        if p3.returncode == 0:
            recs.append(dict(compiler=cc, ksel=k, elf=str(elfk), status='built', reason=''))
        else:
            rb = sorted(set(re.findall(r'>>>\s+\S+\.o:\(([A-Za-z_0-9.]+)\)', p3.stderr)))
            recs.append(dict(compiler=cc, ksel=k, elf=None, status='does not link (B133)',
                             reason='undefined __truncsfbf2 (GAP9 libgcc has no bfloat16 helpers); referenced by ' + ', '.join(rb)[:300]))
    elfr = out / 'prog_rt.elf'
    p4 = link(cc, [o, *extra_objs, *libobjs], elfr, [common['truncsfbf2']['obj']])
    (out / 'link_rt.log').write_text(f'$ {p4.cmd}\n[rc={p4.returncode}]\n{p4.stderr}')
    recs.append(dict(compiler=cc + '+rt', ksel=-1, elf=str(elfr) if p4.returncode == 0 else None,
                     status='built' if p4.returncode == 0 else 'link-fail', reason=p4.stderr[-300:] if p4.returncode else ''))
    return recs


RESULT = re.compile(r'^RESULT kernel=(\S+) cycles=(\d+) instrs=(\d+) checksum=(0x[0-9a-f]+) reps=(\d+) total_cycles=(\d+)', re.M)
OUTF = re.compile(r'^OUTF (\S+) (\d+) (.*)$', re.M)


def parse(text):
    res = collections.OrderedDict()
    for m in RESULT.finditer(text):
        k, c, i, cks, reps, tot = m.groups()
        res[k] = dict(cycles=int(c), instrs=int(i), checksum=cks, reps=int(reps), total_cycles=int(tot))
    for m in OUTF.finditer(text):
        if m.group(1) in res:
            res[m.group(1)]['outf'] = (int(m.group(2)), m.group(3).split())
    return res


def simulate(rec):
    if rec['status'] != 'built':
        return rec, {}
    elf = pathlib.Path(rec['elf'])
    p = sh([SIM / 'run_sim.sh', elf], timeout=SIM_TIMEOUT)
    (elf.parent / (elf.stem + '.sim.log')).write_text(p.stdout + p.stderr)
    res = parse(p.stdout)
    m = re.search(r'\[run_sim\] exit code: (-?\d+)', p.stdout)
    rc = int(m.group(1)) if m else p.returncode
    if rc != 0 or not res:
        tail = [l[:200] for l in (p.stdout + p.stderr).splitlines() if l.strip() and not l.startswith('OUTF')][-3:]
        rec = dict(rec, status='sim-fail', reason=f'rc={rc}; ' + ' | '.join(tail))
    else:
        rec = dict(rec, status='ran')
    return rec, res


def host_ref(prog):
    """Host gcc -O0 reference: all kernels, plus one run per KSEL (to know which kernel names belong
    to which group when a target link has to be split)."""
    out = BUILD / 'host' / prog['id']
    out.mkdir(parents=True, exist_ok=True)
    srcs = [R / 'drivers' / prog['driver'], *prog['extra'], *[LIBS[n] for n in prog['libs']],
            *(TABLES.values() if prog['tables'] else [])]
    inc = prog['defs'] + TABLE_DEFS + (['-I' + str(GEN / prog['gen'])] if prog['gen'] else [])
    groups, full, err = {}, None, ''
    for k in [-1] + list(range(prog['nk'])):
        exe = out / f'prog{"" if k < 0 else "_k%d" % k}'
        p = sh([HOST_CC, *HOST_FLAGS, *inc, *([f'-DKSEL={k}'] if k >= 0 else []), *srcs, '-lm', '-o', exe])
        if p.returncode != 0:
            err = next((l for l in p.stderr.splitlines() if 'error' in l), p.stderr[-300:])
            break
        q = sh([exe], timeout=1800)
        res = parse(q.stdout)
        if q.returncode != 0 or (k < 0 and not res):
            err = f'host run rc={q.returncode} {q.stderr[-200:]}'
            break
        if k < 0:
            full = res
        else:
            groups[k] = list(res)
    return dict(status='ok' if full and not err else 'fail', reason=err, res=full or {}, groups=groups)


# ---------------------------------------------------------------- code size (function + local callees)
def obj_funcs(obj):
    """{name: size} of FUNC symbols and {name: set(callee symbol names)} from relocations."""
    sizes, calls = {}, collections.defaultdict(set)
    for l in sh([NM, '--print-size', '--defined-only', obj]).stdout.splitlines():
        f = l.split()
        if len(f) == 4 and f[2] in 'tT' and int(f[1], 16) > 0 and not f[3].startswith('.L'):   # GCC objects list .L labels too
            sizes[f[3]] = int(f[1], 16)
    cur = None
    for l in sh([OBJDUMP, '-d', '-r', MATTR, obj]).stdout.splitlines():
        m = re.match(r'^[0-9a-f]+ <(.+)>:$', l)
        if m:
            if m.group(1) in sizes:                             # a function; GCC objects also have .L labels here
                cur = m.group(1)
            continue
        m = re.search(r'R_RISCV_\w+\s+([A-Za-z_][\w.$]*)', l)
        if m and cur:
            calls[cur].add(m.group(1))
    return sizes, calls


def closure_size(fn, sizes, calls):
    seen, todo = set(), [fn]
    while todo:
        f = todo.pop()
        if f in seen or f not in sizes:
            continue
        seen.add(f)
        todo += list(calls.get(f, ()))
    return sum(sizes[f] for f in seen), sorted(seen)


def fp(bits, h, dt):
    v = int(h, 16)
    if bits == 32:
        return struct.unpack('<f', struct.pack('<I', v))[0]
    if dt == 'f16a':                                           # bfloat16 = top half of a binary32
        return struct.unpack('<f', struct.pack('<I', v << 16))[0]
    return struct.unpack('<e', struct.pack('<H', v))[0]


def rel_err(a, b, dt):
    """max |a-b| / max |b| over the output (b = reference); inf on NaN/inf or length mismatch."""
    if a is None or b is None or len(a[1]) != len(b[1]):
        return None
    x = [fp(a[0], h, dt) for h in a[1]]
    y = [fp(b[0], h, dt) for h in b[1]]
    if any(math.isnan(v) or math.isinf(v) for v in x + y):
        return float('inf') if a[1] != b[1] else 0.0
    peak = max(abs(v) for v in y) or 1.0
    return max(abs(p - q) for p, q in zip(x, y)) / peak


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--progs'); ap.add_argument('--opts'); ap.add_argument('--jobs', type=int, default=min(24, os.cpu_count() or 8))
    ap.add_argument('--report-only', action='store_true')
    a = ap.parse_args()
    sys.path.insert(0, str(R)); sys.dont_write_bytecode = True
    import report
    if a.report_only:
        report.write(R, json.loads((R / 'results.json').read_text()))
        return
    P = progs()
    if a.progs:
        P = [p for p in P if p['id'] in a.progs.split(',')]
    opts = a.opts.split(',') if a.opts else OPTS
    partial = bool(a.progs or a.opts)
    BUILD.mkdir(exist_ok=True)
    gen_data()
    rows, elfs = [], []
    with concurrent.futures.ThreadPoolExecutor(max_workers=a.jobs) as ex:
        hostf = {p['id']: ex.submit(host_ref, p) for p in P}
        commonf = {(c, o): ex.submit(build_common, c, o) for c in COMPILERS for o in opts}
        common = {k: f.result() for k, f in commonf.items()}
        bj = [(p, c, o) for p in P for c in COMPILERS for o in opts]
        built = list(ex.map(lambda j: build_prog(j[0], j[1], j[2], common[(j[1], j[2])]), bj))
        simj = [(p, c, o, rec) for (p, c, o), recs in zip(bj, built) for rec in recs]
        sims = list(ex.map(lambda j: simulate(j[3]), simj))
        host = {k: f.result() for k, f in hostf.items()}
    # sizes
    fsz = {}
    for (c, o), com in common.items():
        for n in LIBS:
            if com[n]['rc'] == 0:
                fsz[(c, o, n)] = obj_funcs(com[n]['obj'])
    outs = {}                                                   # (kernel, compiler, opt) -> outf, for the float comparison
    for (p, c, o, _), (rec, res) in zip(simj, sims):
        h = host[p['id']]
        names = list(h['res']) if rec['ksel'] < 0 else h['groups'].get(rec['ksel'], [])
        if rec['ksel'] >= 0 and h['status'] == 'ok' and not names:
            continue                                            # this kernel group is empty for this data type
        if not names:
            names = list(res) or [p['id'] + '.<all kernels>']
        for k in names:
            row = dict(kernel=k, prog=p['id'], app=p['app'], dt=p['dt'], category=p['category'], compiler=rec['compiler'], opt=o,
                       function=k.split('.')[1], size_n=int(k.rsplit('.N', 1)[1]) if '.N' in k else None,
                       elf=str(pathlib.Path(rec['elf']).relative_to(R)) if rec['elf'] else None, ksel=rec['ksel'])
            if rec['status'] == 'ran' and k in res:
                r = dict(res[k]); outs[(k, rec['compiler'], o)] = r.pop('outf', None)
                row.update(status='ran', **r)
            elif rec['status'] == 'ran':
                row.update(status='sim-fail', reason='no RESULT line for this kernel')
            else:
                row.update(status=rec['status'], reason=rec['reason'])
            # code size: kernel function + the functions of the DSP library it calls
            fn, cbase = row['function'], rec['compiler'].split('+')[0]
            if fn == 'MatMulSimpleSeq_app_f32':
                d = BUILD / cbase / o / p['id'] / 'driver.o'
                if d.exists():
                    s, cl = obj_funcs(d)
                    row['code_bytes'], row['code_funcs'] = closure_size('MatMulSimpleSeq_app', s, cl)
            else:
                for n in p['libs']:
                    if (cbase, o, n) in fsz and fn in fsz[(cbase, o, n)][0]:
                        s, cl = {}, collections.defaultdict(set)
                        for m in p['libs']:
                            if (cbase, o, m) in fsz:
                                s.update(fsz[(cbase, o, m)][0])
                                for kk, vv in fsz[(cbase, o, m)][1].items():
                                    cl[kk] |= vv
                        row['code_bytes'], row['code_funcs'] = closure_size(fn, s, cl)
                        b133 = [f for f in row['code_funcs'] if '__truncsfbf2' in cl.get(f, ())]
                        if b133:
                            row['truncsfbf2_refs'] = b133
            rows.append(row)
    # correctness
    idx = {(r['kernel'], r['compiler'], r['opt']): r for r in rows}
    for r in rows:
        if r['status'] != 'ran':
            continue
        dt, k = r['dt'], r['kernel']
        h = host[r['prog']]['res'].get(k)
        g = idx.get((k, 'gcc', r['opt']))
        mine = outs.get((k, r['compiler'], r['opt']))
        if h:
            r['exact_vs_host'] = r['checksum'] == h['checksum']
            if dt != 'fix16' and not r['exact_vs_host']:
                r['err_vs_host'] = rel_err(mine, h.get('outf'), dt)
        if g and g['status'].startswith(('ran', 'ok', 'WRONG')) and r['compiler'] != 'gcc':
            r['exact_vs_gcc'] = r['checksum'] == g['checksum']
            if dt != 'fix16' and not r['exact_vs_gcc']:
                r['err_vs_gcc'] = rel_err(mine, outs.get((k, 'gcc', r['opt'])), dt)
    for r in rows:
        if r['status'] != 'ran':
            continue
        tol = TOL.get(r['dt'])
        if r.get('exact_vs_host'):
            r['status'] = 'ok'; r['verdict'] = 'bit-exact vs host'
        elif tol is not None and r.get('err_vs_host') is not None and r['err_vs_host'] <= tol:
            r['status'] = 'ok'; r['verdict'] = f'within tolerance vs host ({r["err_vs_host"]:.1e} <= {tol:g})'
        elif 'exact_vs_host' not in r:
            r['status'] = 'ok?'; r['verdict'] = 'no host reference'
        else:
            r['status'] = 'WRONG'; r['verdict'] = 'differs from host reference' + (f' (err {r["err_vs_host"]:.2e})' if r.get('err_vs_host') is not None else '')
    for h in host.values():
        for v in h['res'].values():
            v.pop('outf', None)
    versions = {c: sh([p, '--version']).stdout.splitlines()[0] for c, p in COMPILERS.items()}
    meta = dict(compilers={c: dict(path=str(p), version=versions[c]) for c, p in COMPILERS.items()}, opts=opts,
                clang_flags=CLANG_FLAGS, gcc_flags=GCC_FLAGS + GCC_ONLY, sdk_cflags=SDK_CFLAGS, includes=INC, driver_flags=DRV_FLAGS,
                host_cc=sh([HOST_CC, '--version']).stdout.splitlines()[0], host_flags=HOST_FLAGS, rt_reps=RT_REPS, tolerance=TOL,
                simulator='GVSoC2 ri5ky_testbench (one RI5CY/GAP9 core) via benchmarks/gap9-sweep/sim/run_sim.sh, crt0 slow mode',
                sdk=str(SDK), progs=[{k: (str(v) if isinstance(v, pathlib.Path) else [str(x) for x in v] if isinstance(v, list) else v)
                                      for k, v in p.items()} for p in P],
                common_failures={f'{c}/{o}/{n}': v['err'][-300:] for (c, o), com in common.items() for n, v in com.items() if v['rc'] != 0})
    data = dict(meta=meta, host={k: dict(status=v['status'], reason=v['reason'], kernels=v['res']) for k, v in host.items()}, rows=rows)
    name = 'results.partial.json' if partial else 'results.json'
    (R / name).write_text(json.dumps(data, indent=1))
    print(collections.Counter((r['compiler'], r['opt'], r['status']) for r in rows))
    if not partial:
        report.write(R, data)


if __name__ == '__main__':
    main()
