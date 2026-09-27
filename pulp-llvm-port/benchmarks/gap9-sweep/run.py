#!/usr/bin/env python3
"""GAP9 SDK kernel sweep, static part: compile every kernel with ref18/port19/port20/GAP9 GCC
at -O2/-O3, disassemble with port20 llvm-objdump, and record per-function size, instruction
count and PULP instruction-family mix. Writes build/, results.json, commands.json, report.md.

  python3 run.py            # from any directory; reruns everything (about a minute)

Nothing outside this directory is modified. SDK sources are used read-only; functions that
cannot be compiled as a whole file are extracted verbatim into build/gen/.
"""
import collections, concurrent.futures, hashlib, json, os, pathlib, re, shutil, subprocess

D = pathlib.Path(__file__).resolve().parent
H = D.parent.parent                                   # pulp-llvm-port/
SDK = pathlib.Path('/home/ubuntu/gap_sdk_release')
AT = SDK / 'tools/autotiler_v3'
DSP = AT / 'BasicKernels/DSP_Libraries'
GCCROOT = pathlib.Path('/home/ubuntu/gap_riscv_toolchain_ubuntu')
TC = H / 'toolchains'
COMPILERS = {  # frozen
    'ref18': TC / 'ref-18/bin/clang',
    'port19': TC / 'port-19/bin/clang',
    'port20': TC / 'port-20/bin/clang',
    'gcc': GCCROOT / 'bin/riscv32-unknown-elf-gcc',
}
# Extra LLVM compilers for later reruns without editing this file:
#   GAP9_EXTRA_COMPILERS="port20fix=/path/to/clang,other=/path/to/clang" python3 run.py
for _spec in filter(None, os.environ.get('GAP9_EXTRA_COMPILERS', '').split(',')):
    _name, _, _path = _spec.partition('=')
    COMPILERS[_name.strip()] = pathlib.Path(_path.strip())
OBJDUMP = TC / 'port-20/bin/llvm-objdump'
NM = TC / 'port-20/bin/llvm-nm'
# +m is needed for GCC 7 objects: they carry no .riscv.attributes, so without it `mul` decodes as
# <unknown>. It does not change the disassembly of the clang objects (which carry rv32imc attributes).
MATTR = '--mattr=+m,+xpulpv,+zfinx'
LLVM_FLAGS = ['--target=riscv32-unknown-elf', '-march=rv32imc_zfinx_xpulpv2', '-mabi=ilp32', '-mno-relax',
              '-isystem', str(GCCROOT / 'riscv32-unknown-elf/include')]
GCC_FLAGS = ['-march=rv32imcxgap9', '-mPE=8', '-mFC=1']      # -mint64 not needed by any kernel
OPTS = ['O2', 'O3']
TIMEOUT = 300
SRC, BUILD, GEN = D / 'src', D / 'build', D / 'build/gen'
INCLUDES = ['-I' + str(SRC / 'shim'), '-I' + str(GEN), '-I' + str(DSP), '-I' + str(DSP / 'FastMathFunctions'),
            '-I' + str(AT / 'Emulation'),
            '-D__gap9__', '-D__GAP9__', '-D__pulp__']

CK = SDK / 'examples/gap9/basic/getting_started/cluster_kernels.c'
MM = SDK / 'examples/gap9/dsp/benchmarks/MatMul/MatMulRunTest.c'
FFT = DSP / 'TransformFunctions/FftLibraryFix.c'
PRE = [('var', 'CoreCountDynamic'), ('var', 'ActiveCore'), ('func', 'ChunkSize')]
# id, source TU in src/, measured functions, provenance, optional extraction spec (file, items, targets)
KERNELS = [
    ('k01_fir_fix16', ['KerFirSeqBaseline', 'KerFirSeq'], 'FirBasicKernelsFix.c (whole file)', None),
    ('k02_fir_f32', ['KerFirSeqBaselinef32', 'KerFirSeqf32'], 'FirBasicKernelsf32.c (whole file)', None),
    ('k03_matmul_worker_i16', ['matmul_worker'], 'cluster_kernels.c (extract)',
     (CK, [('typedef', 'worker_args_t'), ('func', 'min_int'), ('func', 'ChunkSize'), ('func', 'matmul_worker')], ['matmul_worker'])),
    ('k04_matmul_simple_f32', ['MatMulSimpleSeq'], 'MatMulRunTest.c (extract)',
     (MM, [('func', 'MatMulSimpleSeq')], ['MatMulSimpleSeq'])),
    ('k05_matmul_dsp_fix16', ['KerParMatMulDSP_Fix16'], 'MatMulDSP.c (extract)',
     (DSP / 'MatrixFunctions/MatMulDSP.c', PRE + [('func', 'KerParMatMulDSP_Fix16')], [])),
    ('k05_matmul_dsp_fix16-file', ['KerParMatMulDSP_Fix16'], 'MatMulDSP.c (whole file)', None),
    ('k06_matvect_dsp_f32', ['KerParMatVectDSP_f32'], 'MatVectDSP.c (extract; file has no fixed-point kernel)',
     (DSP / 'MatrixFunctions/MatVectDSP.c', PRE + [('func', 'KerParMatVectDSP_f32')], [])),
    ('k06_matvect_dsp_f32-file', ['KerParMatVectDSP_f32'], 'MatVectDSP.c (whole file)', None),
    ('k07_matadd_dsp_fix16', ['KerParMatAdd_DSP_Fix16'], 'MatAddDSP.c (extract)',
     (DSP / 'MatrixFunctions/MatAddDSP.c', PRE + [('func', 'KerParMatAdd_DSP_Fix16')], [])),
    ('k07_matadd_dsp_fix16-file', ['KerParMatAdd_DSP_Fix16'], 'MatAddDSP.c (whole file)', None),
    ('k08_preprocessing_fix', ['PreEmphasis', 'WindowingReal2Cmplx_Fix16', 'WindowingReal2Real_Fix16'],
     'PreProcessingFix.c (whole file)', None),
    ('k09_cmplx_fix', ['CmplxMagSquared_Fix16'], 'CmplxFunctionsFix.c (whole file)', None),
    ('k10a_fft_radix2_scalar', ['Radix2FFT_DIF_Scalar'], 'FftLibraryFix.c (extract)',
     (FFT, [('define', 'FFT2_SCALEDOWN'), ('func', 'Radix2FFT_DIF_Scalar')], [])),
    ('k10b_fft_radix2_seq_fix16', ['Radix2FFT_DIF_Seq_Fix16'], 'FftLibraryFix.c (extract)',
     (FFT, [('func', 'Radix2FFT_DIF_Seq_Fix16')], [])),
    ('k10_fft-file', ['Radix2FFT_DIF_Scalar', 'Radix2FFT_DIF_Seq_Fix16'], 'FftLibraryFix.c (whole file)', None),
    ('k11_dotprod_i8', ['dotprod_i8'], 'written for sweep (gap_sumdotp4 loop)', None),
    ('clip', ['clip_s8', 'clipu_u8'], 'written for sweep (p.clip probe)', None),
]
# Kernel 12: the 19-vs-18 regression anchor, split one function per TU exactly as
# benchmarks/19-vs-18/run.py does (the 4 typedef lines + one function line).
ANCHOR = D.parent / '19-vs-18/kernels.c'
_al = ANCHOR.read_text().splitlines()
ANCHOR_TUS = {}
for _l in _al[4:]:
    _n = re.search(r'(\w+)\(', _l)[1]
    ANCHOR_TUS['k12_' + _n] = '\n'.join(_al[:4] + [_l]) + '\n'
    KERNELS.append(('k12_' + _n, [_n], '19-vs-18/kernels.c line (anchor)', None))

# PULP instruction families. Post-increment requires the '!' writeback operand; register-offset
# p.l*/p.s* without '!' are counted as 'p-regoff'.
FAMILIES = [
    ('hwloop', lambda m, o: m.startswith('lp.')),
    ('postinc', lambda m, o: re.match(r'p\.(lb|lbu|lh|lhu|lw|sb|sh|sw)$', m) and '!' in o),
    ('p-regoff', lambda m, o: re.match(r'p\.(lb|lbu|lh|lhu|lw|sb|sh|sw)$', m)),
    ('simd', lambda m, o: m.startswith('pv.')),
    ('mac', lambda m, o: re.match(r'p\.(mac|msu)', m)),
    ('clip', lambda m, o: m.startswith('p.clip')),
    ('bitmanip', lambda m, o: re.match(r'p\.(extract|insert|bclr|bset|cnt|ff1|fl1|clb|ror|bitrev)', m)),
    ('p-other', lambda m, o: m.startswith('p.')),
]
LINE = re.compile(r'^\s*([0-9a-f]+):\s+((?:[0-9a-f]{2,8}\s)+)\s*(\S+)\s*(.*)$')
FUNC = re.compile(r'^[0-9a-f]+ <(.+)>:$')
commands = []


def sha(p):
    return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()


def find_block(lines, i):
    """From line i, return index of the line holding the brace that closes the first '{'."""
    depth, seen = 0, False
    for j in range(i, len(lines)):
        for ch in lines[j]:
            if ch == '{':
                depth += 1; seen = True
            elif ch == '}':
                depth -= 1
                if seen and depth == 0:
                    return j
    raise ValueError('unbalanced')


def extract(path, items, unstatic):
    lines = path.read_text().splitlines()
    out = [f'/* Generated by run.py: verbatim extract from {path}', f' * sha256 {sha(path)}']
    body = []
    for kind, name in items:
        if kind == 'func':
            i = next(k for k, l in enumerate(lines) if re.match(rf'^[A-Za-z].*\b{name}\s*\(', l) and not l.rstrip().endswith(';'))
            j = find_block(lines, i)
        elif kind == 'var':
            i = j = next(k for k, l in enumerate(lines) if re.match(rf'^static\s+\w+\s+{name}\s*=.*;', l))
        elif kind == 'define':
            i = j = next(k for k, l in enumerate(lines) if re.match(rf'^#define\s+{name}\b', l))
        elif kind == 'typedef':
            j = next(k for k, l in enumerate(lines) if re.match(rf'^\}}\s*{name}\s*;', l))
            i = max(k for k in range(j) if lines[k].startswith('typedef'))
        out.append(f' *   {kind} {name}: lines {i + 1}-{j + 1}')
        chunk = lines[i:j + 1]
        if kind == 'func' and name in unstatic:
            chunk[0] = re.sub(r'^static\s+', '', chunk[0])
        body += [f'#line {i + 1} "{path}"'] + chunk + ['']
    if unstatic:
        out.append(' *   leading "static" removed from: ' + ', '.join(unstatic))
    return '\n'.join(out + [' */'] + body) + '\n'


def run(cmd, **kw):
    commands.append([str(c) for c in cmd])
    try:
        return subprocess.run([str(c) for c in cmd], text=True, capture_output=True, timeout=TIMEOUT, **kw)
    except subprocess.TimeoutExpired:
        return subprocess.CompletedProcess(cmd, -999, '', f'TIMEOUT after {TIMEOUT}s')


def classify(p):
    if p.returncode == 0:
        return 'ok', None
    err = p.stderr
    if p.returncode == -999:
        return 'timeout', err
    a = re.search(r'Assertion `(.+?)\' failed', err)
    passes = re.findall(r"Running pass '([^']+)' on function '([^']+)'", err)
    crashed = 'Stack dump' in err or 'PLEASE submit a bug report' in err or 'internal compiler error' in err
    if a:
        where = f" (pass '{passes[-1][0]}' on {passes[-1][1]})" if passes else ''
        return 'assert', 'Assertion `' + a.group(1) + "' failed" + where
    if crashed:
        if passes:
            return 'crash', f"crash in pass '{passes[-1][0]}' on {passes[-1][1]}"
        ice = re.search(r'internal compiler error: .*', err)
        return 'crash', ice.group(0) if ice else 'crash: ' + next((l for l in err.splitlines() if 'error' in l), '?')
    first = next((l for l in err.splitlines() if re.search(r'\berror\b', l)), err.strip().splitlines()[0] if err.strip() else '?')
    return 'error', first.replace(str(SDK) + '/', '$SDK/').replace(str(D) + '/', '')


def parse(dis, nm):
    sizes = {}
    for l in nm.splitlines():
        f = l.split()
        if len(f) == 4 and f[2].lower() == 't':
            sizes[f[3]] = int(f[1], 16)
    funcs, cur = collections.defaultdict(list), None
    for l in dis.splitlines():
        m = FUNC.match(l)
        if m:
            if not m.group(1).startswith('.L'):   # GCC keeps .L local labels as symbols
                cur = m.group(1)
            continue
        m = LINE.match(l)
        if m and cur:
            funcs[cur].append((m.group(3), m.group(4), len(''.join(m.group(2).split())) // 2))
    res = {}
    for f, ins in funcs.items():
        mix, mn = collections.Counter(), collections.Counter()
        unknown = 0
        for m, o, _ in ins:
            if m == '<unknown>':
                unknown += 1; mn[m] += 1; continue
            mn[m] += 1
            for name, pred in FAMILIES:
                if pred(m, o):
                    mix[name] += 1; break
        clip_imms = [o for m, o, _ in ins if m.startswith('p.clip')]
        decoded = sum(n for _, _, n in ins)
        res[f] = dict(size=sizes.get(f), decoded_bytes=decoded, instructions=len(ins), unknown=unknown, mix=dict(mix),
                      mnemonics=dict(mn), clip_operands=clip_imms)
    return res


def compile_one(kernel, funcs, compiler, opt):
    out = BUILD / compiler / opt
    obj = out / f'{kernel}.o'
    src = (GEN if kernel in ANCHOR_TUS else SRC) / f'{kernel}.c'
    flags = GCC_FLAGS if compiler == 'gcc' else LLVM_FLAGS
    cmd = [COMPILERS[compiler], *flags, *INCLUDES, '-' + opt, '-c', src, '-o', obj]
    if obj.exists():
        obj.unlink()
    p = run(cmd)
    (out / f'{kernel}.stderr').write_text(p.stderr)
    status, detail = classify(p)
    row = dict(kernel=kernel, compiler=compiler, opt=opt, status=status, detail=detail, returncode=p.returncode)
    if status != 'ok':
        return row
    dis = run([OBJDUMP, '-d', MATTR, obj]).stdout
    nm = run([NM, '-S', '--defined-only', obj]).stdout
    (out / f'{kernel}.dis').write_text(dis)
    (out / f'{kernel}.symbols').write_text(nm)
    allf = parse(dis, nm)
    want = funcs if funcs is not None else sorted(allf)
    row['functions'] = {f: allf.get(f, dict(missing=True)) for f in want}
    for f, v in row['functions'].items():
        assert not v.get('missing') and v['size'] == v['decoded_bytes'], (kernel, compiler, opt, f)
    row['object_sha256'] = sha(obj)
    row['warnings'] = len(re.findall(r'warning:', p.stderr))
    return row


def main():
    if BUILD.exists():
        shutil.rmtree(BUILD)
    GEN.mkdir(parents=True)
    for c in COMPILERS:
        for o in OPTS:
            (BUILD / c / o).mkdir(parents=True)
    for kernel, text in ANCHOR_TUS.items():
        (GEN / f'{kernel}.c').write_text(text)
    for kernel, funcs, prov, spec in KERNELS:
        if spec:
            (GEN / f'{kernel}.extract.c').write_text(extract(*spec))
    jobs = [(k, f, c, o) for k, f, _, _ in KERNELS for c in COMPILERS for o in OPTS]
    with concurrent.futures.ThreadPoolExecutor(max_workers=min(16, os.cpu_count() or 4)) as ex:
        rows = list(ex.map(lambda j: compile_one(*j), jobs))
    versions = {c: run([p, '--version']).stdout.splitlines()[0] for c, p in COMPILERS.items()}
    sdk_head = subprocess.run(['git', '-C', str(SDK), 'rev-parse', 'HEAD'], text=True, capture_output=True).stdout.strip()
    meta = dict(compilers={c: dict(path=str(p), version=versions[c]) for c, p in COMPILERS.items()},
                objdump=f'{OBJDUMP} -d {MATTR}', llvm_flags=LLVM_FLAGS, gcc_flags=GCC_FLAGS,
                includes=INCLUDES, sdk=str(SDK), sdk_head=sdk_head,
                kernels=[dict(kernel=k, functions=f, source=p) for k, f, p, _ in KERNELS],
                families={'hwloop': 'lp.*', 'postinc': 'p.l*/p.s* with rs1! writeback',
                          'p-regoff': 'p.l*/p.s* register-offset, no writeback', 'simd': 'pv.*',
                          'mac': 'p.mac*/p.msu*', 'clip': 'p.clip*',
                          'bitmanip': 'p.extract/insert/bclr/bset/cnt/ff1/fl1/clb/ror/bitrev',
                          'p-other': 'other p.* (abs/min/max/exths/addN/...)',
                          'unknown': 'words port20 llvm-objdump cannot decode (GAP9-only encodings)'})
    (D / 'results.json').write_text(json.dumps(dict(meta=meta, rows=rows), indent=1))
    (D / 'commands.json').write_text(json.dumps(commands, indent=1))
    import report
    report.write(D, meta, rows)
    ok = collections.Counter((r['compiler']) for r in rows if r['status'] == 'ok')
    print('rows', len(rows), 'ok per compiler', dict(ok))


if __name__ == '__main__':
    import sys
    sys.dont_write_bytecode = True
    sys.path.insert(0, str(D))
    main()
