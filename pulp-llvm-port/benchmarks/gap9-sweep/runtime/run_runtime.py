#!/usr/bin/env python3
"""GAP9 SDK kernel sweep, runtime (cycle-count) part.

For every kernel that the static sweep (../results.json) compiles with at least one LLVM compiler,
build  crt0 + driver + kernel TU + memcpy/memset  with each compiler at -O2/-O3, run it on the
GVSoC2 ri5ky_testbench (../sim/run_sim.sh), parse the driver's RESULT line and check the output
checksum against the GAP9 GCC build (reference) and a host-gcc build of the same sources.

  python3 run_runtime.py                              # all default compilers, everything
  python3 run_runtime.py --add port20fix=/path/to/clang   # extra compiler, no code changes
  python3 run_runtime.py --compilers ref18,port20,gcc --kernels k03_matmul_worker_i16
  python3 run_runtime.py --report-only                # rebuild runtime_report.md from the JSON

Writes build/ (objects, ELFs, disassembly, logs), runtime_results.json, runtime_report.md.
The kernel TU is compiled with exactly the static sweep's command (flags from ../run.py);
nothing outside this directory is written.
"""
import argparse, collections, concurrent.futures, hashlib, json, math, os, pathlib, re, shutil, subprocess, sys

R = pathlib.Path(__file__).resolve().parent            # runtime/
D = R.parent                                           # gap9-sweep/
H = D.parent.parent                                    # pulp-llvm-port/
SIM = D / 'sim'
sys.dont_write_bytecode = True
sys.path.insert(0, str(D))
import run as sweep                                    # static sweep: flags, includes, sources (read only)

TC = H / 'toolchains'
DEFAULT_COMPILERS = {
    'ref18': TC / 'ref-18/bin/clang',
    'port19': TC / 'port-19/bin/clang',
    'port20': TC / 'port-20/bin/clang',
    'gcc': sweep.GCCROOT / 'bin/riscv32-unknown-elf-gcc',
}
BASELINE, REFERENCE = 'ref18', 'gcc'
OPTS = ['O2', 'O3']
WORKAROUND = ['-mllvm', '-pulp-loop-range-immediate=0']
WA_LABEL = 'workaround: -pulp-loop-range-immediate=0 (one extra instruction per hwloop)'
LPSETUPI = re.compile(r'RISCVMCCodeEmitter|Unhandled expression|immediate must be an integer in the range \[0, 31\]')
DRIVER_FLAGS = ['-ffreestanding', '-fno-builtin', '-I' + str(SIM), '-I' + str(R)]
HOST_CC = 'gcc'
HOST_FLAGS = ['-O2', '-fwrapv', '-DRT_HOST', '-include', str(R / 'hostshim/pulp_emul.h'), '-I' + str(R / 'hostshim'),
              '-I' + str(sweep.GEN), '-I' + str(sweep.DSP), '-I' + str(sweep.DSP / 'FastMathFunctions'),
              '-I' + str(sweep.AT / 'Emulation'), '-I' + str(R), '-D__EMUL__', '-w']
FP_KERNELS = {'k06_matvect_dsp_f32': 1e-4, 'k04_matmul_simple_f32': 1e-4, 'k02_fir_f32': 1e-4}             # relative tolerance vs reference (fp32 sums)
# Known LLVM encoding bugs that explain a checksum mismatch (verified in the kernel disassembly).
KNOWN_BUGS = {
    'clip': 'p.clip off-by-one: __builtin_pulp_clip(x,-128,127) encoded as p.clip ...,7 (GCC 8) = clamp to [-64,63]',
    'k05_matmul_dsp_fix16': 'p.clip off-by-one: gap_clip(x,15) encoded as p.clip ...,15 (GCC 16) = clamp to [-16384,16383]',
    'k12_bit_extract': 'p.extractu off-by-one: __builtin_pulp_bextractu(a,8,8) encoded as p.extractu ...,8,8 (GCC 7,8) = 9-bit field',
}
# How the host reference gets PULP semantics (for the report).
HOST_SEM = {k: 'SDK Emulation/GapBuiltins.h (__EMUL__ plain-C branch)' for k in
            ['k01_fir_fix16', 'k02_fir_f32', 'k03_matmul_worker_i16', 'k05_matmul_dsp_fix16', 'k06_matvect_dsp_f32',
                  'k07_matadd_dsp_fix16', 'k08_preprocessing_fix', 'k09_cmplx_fix', 'k10a_fft_radix2_scalar', 'k11_dotprod_i8']}
HOST_SEM.update({k: 'hand-written builtin model (hostshim/pulp_emul.h)' for k in
                 ['clip', 'k12_packed_max8', 'k12_dot8', 'k12_dot16', 'k12_bit_extract', 'k12_dot8_loop', 'k12_dot16_loop']})
SIM_TIMEOUT, CC_TIMEOUT = 900, 300
BUILD = R / 'build'


def sh(cmd, timeout=CC_TIMEOUT, **kw):
    cmd = [str(c) for c in cmd]
    try:
        p = subprocess.run(cmd, text=True, capture_output=True, timeout=timeout, **kw)
    except subprocess.TimeoutExpired:
        p = subprocess.CompletedProcess(cmd, -999, '', f'TIMEOUT after {timeout}s')
    p.cmd = ' '.join(cmd)
    return p


def sha(p):
    return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()


def is_gcc(path):
    return 'gcc' in pathlib.Path(path).name


def kernel_src(k):
    return (sweep.GEN if k in sweep.ANCHOR_TUS else sweep.SRC) / f'{k}.c'


def select_kernels():
    """Kernels with at least one LLVM 'ok' row in the static sweep."""
    rows = json.loads((D / 'results.json').read_text())['rows']
    ok = collections.defaultdict(set)
    for r in rows:
        if r['status'] == 'ok' and r['compiler'] != 'gcc':
            ok[r['kernel']].add((r['compiler'], r['opt']))
    order = [k for k, *_ in sweep.KERNELS]
    ks = [k for k in order if ok.get(k)]
    static = {(r['kernel'], r['compiler'], r['opt']): r for r in rows}
    return ks, static


def reason(p):
    st, detail = sweep.classify(p)
    if LPSETUPI.search(p.stderr or ''):
        return 'lp.setupi object-emission crash (RISCVMCCodeEmitter "Unhandled expression")'
    if st == 'error' and 'undefined symbol' in (p.stderr or ''):
        return 'link: ' + next(l for l in p.stderr.splitlines() if 'undefined symbol' in l).strip()
    return f'{st}: {detail}'


def build(kernel, cc, path, opt, wa_kernel=False):
    """Compile + link one ELF. Returns a row dict (no simulation yet)."""
    name = cc + ('+wa' if wa_kernel else '')
    out = BUILD / name / opt / kernel
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True)
    gcc = is_gcc(path)
    base = sweep.GCC_FLAGS if gcc else sweep.LLVM_FLAGS
    wa = WORKAROUND if wa_kernel else []
    row = dict(kernel=kernel, compiler=name, base_compiler=cc, opt=opt, workaround=wa_kernel, notes=[])
    log = []

    def step(tag, cmd):
        p = sh(cmd)
        log.append(f'$ {p.cmd}\n[rc={p.returncode}]\n{p.stderr}')
        (out / f'{tag}.stderr').write_text(p.stderr or '')
        return p

    # 1. kernel TU: exactly the static sweep's command (+ workaround flag on the labelled +wa row)
    ko = out / 'kernel.o'
    p = step('kernel', [path, *base, *sweep.INCLUDES, '-' + opt, *wa, '-c', kernel_src(kernel), '-o', ko])
    if p.returncode != 0:
        row.update(status='compile-fail', reason=reason(p), stage='kernel')
        (out / 'build.log').write_text('\n'.join(log))
        return row
    row['kernel_obj_sha256'] = sha(ko)
    so = sweep.BUILD / cc / opt / f'{kernel}.o'
    if not wa_kernel and not gcc and so.exists():
        row['kernel_obj_same_as_static_sweep'] = sha(so) == row['kernel_obj_sha256']
    objdump = TC / 'port-20/bin/llvm-objdump'
    (out / 'kernel.dis').write_text(sh([objdump, '-d', sweep.MATTR, ko]).stdout)
    # 2. driver + memcpy/memset + crt0, same compiler and opt level
    objs = []
    for tag, src, extra in [('crt0', SIM / 'crt0.S', []), ('driver', R / 'drivers' / f'{kernel}.c', DRIVER_FLAGS),
                            ('rt_libc', R / 'rt_libc.c', DRIVER_FLAGS)]:
        o = out / f'{tag}.o'
        cmd = [path, *base, '-' + opt, *extra, *wa, '-c', src, '-o', o]
        p = step(tag, cmd)
        if p.returncode != 0 and not gcc and not wa and LPSETUPI.search(p.stderr or ''):
            p = step(tag, cmd[:-4] + WORKAROUND + cmd[-4:])
            row['notes'].append(f'{tag} (not timed code) needed the lp.setupi workaround flag')
        if p.returncode != 0:
            row.update(status='compile-fail', reason=f'{tag}: ' + reason(p), stage=tag)
            (out / 'build.log').write_text('\n'.join(log))
            return row
        objs.append(o)
    elf = out / 'prog.elf'
    if gcc:
        cmd = [path, *base, '-nostdlib', '-static', '-T', SIM / 'link.ld', *objs, ko, '-lgcc', '-o', elf]
    else:
        lld = pathlib.Path(path).parent / 'ld.lld'
        lld = lld if lld.exists() else TC / 'port-20/bin/ld.lld'
        libgcc = sweep.GCCROOT / 'lib/gcc/riscv32-unknown-elf/7.1.1/rv32imcxgap9/ilp32/libgcc.a'
        cmd = [lld, '-nostdlib', '-static', '-T', SIM / 'link.ld', *objs, ko, libgcc, '-o', elf]
    p = step('link', cmd)
    (out / 'build.log').write_text('\n'.join(log))
    if p.returncode != 0:
        row.update(status='link-fail', reason=reason(p), stage='link')
        return row
    row.update(status='built', elf=str(elf.relative_to(R)))
    return row


RESULT = re.compile(r'^RESULT kernel=(\S+) cycles=(\d+) instrs=(\d+) checksum=(0x[0-9a-f]+) reps=(\d+) '
                    r'total_cycles=(\d+) pccr_cycles=(\d+)', re.M)


def parse_result(text):
    m = RESULT.search(text)
    if not m:
        return None
    k, c, i, cks, reps, tot, pc = m.groups()
    res = dict(cycles=int(c), instrs=int(i), checksum=cks, reps=int(reps), total_cycles=int(tot), pccr_cycles=int(pc))
    f = re.search(r'^OUTF (.*)$', text, re.M)
    if f:
        res['outf'] = f.group(1).split()
    return res


def simulate(row):
    if row['status'] != 'built':
        return row
    p = sh([SIM / 'run_sim.sh', R / row['elf']], timeout=SIM_TIMEOUT)
    elf = R / row['elf']
    (elf.parent / 'sim.log').write_text(p.stdout + p.stderr)
    res = parse_result(p.stdout)
    if p.returncode != 0 or res is None:
        tail = [l for l in (p.stdout + p.stderr).splitlines() if l.strip()][-3:]
        row.update(status='sim-fail', reason=f'rc={p.returncode}; ' + ' | '.join(tail))
        return row
    row.update(status='ran', **res)
    return row


def host_ref(kernel):
    out = BUILD / 'host' / kernel
    out.mkdir(parents=True, exist_ok=True)
    exe = out / 'prog'
    p = sh([HOST_CC, *HOST_FLAGS, R / 'drivers' / f'{kernel}.c', kernel_src(kernel), '-o', exe])
    (out / 'build.stderr').write_text(p.stderr)
    sem = HOST_SEM.get(kernel, 'plain C (no PULP builtins)')
    if p.returncode != 0:
        err = next((l for l in p.stderr.splitlines() if 'error' in l), p.stderr.strip()[:200])
        return dict(status='compile-fail', reason=err.replace(str(sweep.SDK) + '/', '$SDK/'), semantics=sem)
    q = sh([exe])
    res = parse_result(q.stdout)
    if res is None:
        return dict(status='run-fail', reason=q.stderr[:200], semantics=sem)
    return dict(status='ok', checksum=res['checksum'], outf=res.get('outf'), semantics=sem)


def f32(h):
    import struct
    return struct.unpack('<f', int(h, 16).to_bytes(4, 'little'))[0]


def judge(rows, host):
    """Attach correctness to every 'ran' row. Reference = GCC -O2 checksum."""
    ref = {}
    for r in rows:
        if r['base_compiler'] == REFERENCE and r['opt'] == 'O2' and r['status'] == 'ran':
            ref[r['kernel']] = r
    for r in rows:
        if r['status'] != 'ran':
            continue
        g = ref.get(r['kernel'])
        h = host.get(r['kernel'], {})
        r['matches_host'] = (h.get('checksum') == r['checksum']) if h.get('status') == 'ok' else None
        if FP_KERNELS.get(r['kernel']) and h.get('outf') and r.get('outf'):
            r['max_rel_err_vs_host'] = max(abs(f32(a) - f32(b)) / max(abs(f32(b)), 1e-6)
                                           for a, b in zip(r['outf'], h['outf']))
        if g is None:
            r['status'] = 'ok?'; r['reason'] = 'no GCC reference'; continue
        r['matches_gcc'] = r['checksum'] == g['checksum']
        if r['matches_gcc']:
            r['status'] = 'ok'
            continue
        tol = FP_KERNELS.get(r['kernel'])
        if tol and r.get('outf') and g.get('outf') and len(r['outf']) == len(g['outf']):
            worst = max(abs(f32(a) - f32(b)) / max(abs(f32(b)), 1e-6) for a, b in zip(r['outf'], g['outf']))
            r['max_rel_err'] = worst
            if worst <= tol:
                r['status'] = 'ok'; r['notes'].append(f'fp32 not bit-exact vs GCC, max rel err {worst:.2e} <= {tol}')
                continue
        r['status'] = 'WRONG RESULT'
        r['reason'] = f"checksum {r['checksum']} != GCC {g['checksum']}"
        if r['kernel'] in KNOWN_BUGS:
            r['reason'] += '; cause: ' + KNOWN_BUGS[r['kernel']]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--add', action='append', default=[], metavar='NAME=CLANG', help='add/override a compiler')
    ap.add_argument('--compilers', help='comma list (default: all defaults + --add)')
    ap.add_argument('--kernels', help='comma list (default: all selected from ../results.json)')
    ap.add_argument('--jobs', type=int, default=os.cpu_count() or 8)
    ap.add_argument('--no-workaround', action='store_true', help='do not add +wa rows for lp.setupi crashes')
    ap.add_argument('--report-only', action='store_true')
    a = ap.parse_args()
    if a.report_only:
        data = json.loads((R / 'runtime_results.json').read_text())
        sys.path.insert(0, str(R))
        import runtime_report
        runtime_report.write(R, data)
        return
    comps = dict(DEFAULT_COMPILERS)
    for s in a.add:
        n, p = s.split('=', 1)
        comps[n] = pathlib.Path(p)
    if a.compilers:
        comps = {n: comps[n] for n in a.compilers.split(',')}
    assert REFERENCE in comps, 'the GCC reference compiler is required'
    kernels, static = select_kernels()
    if a.kernels:
        kernels = [k for k in kernels if k in a.kernels.split(',')]
    missing = [k for k in kernels if not (R / 'drivers' / f'{k}.c').exists()]
    assert not missing, f'no driver for {missing}'
    if BUILD.exists() and not a.kernels and not a.compilers:
        shutil.rmtree(BUILD)
    jobs = [(k, c, comps[c], o) for k in kernels for c in comps for o in OPTS]
    with concurrent.futures.ThreadPoolExecutor(max_workers=a.jobs) as ex:
        rows = list(ex.map(lambda j: build(*j), jobs))
        extra = [(r['kernel'], r['compiler'], comps[r['compiler']], r['opt'], True) for r in rows
                 if not a.no_workaround and r['status'] == 'compile-fail' and r['reason'].startswith('lp.setupi')]
        rows += list(ex.map(lambda j: build(*j), extra))
        host_f = {k: ex.submit(host_ref, k) for k in kernels}
        rows = list(ex.map(simulate, rows))
        host = {k: f.result() for k, f in host_f.items()}
    judge(rows, host)
    for r in rows:
        r.pop('outf', None)
    for h in host.values():
        h.pop('outf', None)
    versions = {c: sh([p, '--version']).stdout.splitlines()[0] for c, p in comps.items()}
    meta = dict(compilers={c: dict(path=str(p), version=versions[c]) for c, p in comps.items()},
                baseline=BASELINE, reference=REFERENCE, opts=OPTS, kernels=kernels,
                llvm_flags=sweep.LLVM_FLAGS, gcc_flags=sweep.GCC_FLAGS, includes=sweep.INCLUDES,
                driver_flags=DRIVER_FLAGS, host_cc=sh([HOST_CC, '--version']).stdout.splitlines()[0],
                host_flags=HOST_FLAGS, workaround=' '.join(WORKAROUND), workaround_label=WA_LABEL,
                simulator='GVSoC2 ri5ky_testbench via ../sim/run_sim.sh (crt0.S slow mode, PCCR on)',
                static_status={f'{k}|{c}|{o}': (static[(k, c, o)]['status'] if (k, c, o) in static else None)
                               for k in kernels for c in comps for o in OPTS})
    data = dict(meta=meta, host=host, rows=rows)
    (R / 'runtime_results.json').write_text(json.dumps(data, indent=1))
    sys.path.insert(0, str(R))
    import runtime_report
    runtime_report.write(R, data)
    print(collections.Counter((r['compiler'], r['status']) for r in rows))


if __name__ == '__main__':
    main()
