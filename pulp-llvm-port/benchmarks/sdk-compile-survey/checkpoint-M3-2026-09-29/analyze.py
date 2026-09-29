#!/usr/bin/env python3
"""M3 checkpoint analysis (M2a's analyze.py, baselines switched): config P
(-march=rv32imc_xgap9 -mPE=8, no shim) and config X (-march=rv32imc_xgap9, no -mPE,
no shim) vs the M1 checkpoint (476/617, its config B) and the M2a checkpoint (per file,
P 520 / X 515). Adds per-file GCC status with the SDK's own -Werror flags (gccsdk) and
clang's sdkflags / sdknowerror results.
usage: analyze.py <work> <outdir> <M1 results.json> <M2a results.json>"""
import collections, json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import run

W, OUT, M1, M2A = sys.argv[1:5]
inv = json.load(open(W + '/inventory.json'))
comp = {}
for m in ('gcc', 'gccsdk', 'sdkflags', 'sdknowerror', 'pe8', 'pe8lenient', 'xgap9', 'xgap9lenient', 'pe8abs', 'pe8abslenient'):
    p = '%s/compile_%s.json' % (W, m)
    comp[m] = json.load(open(p)) if os.path.exists(p) else {}
m1 = json.load(open(M1))
m1ok = {r['file'] for r in m1['files'] if r['B']['ok']}
m1files = {r['file'] for r in m1['files']}
m2a = json.load(open(M2A))
m2aP = {r['file'] for r in m2a['files'] if r['P']['ok']}
m2aX = {r['file'] for r in m2a['files'] if r['X']['ok']}
m2aQ = {r['file'] for r in m2a['files'] if r['Q']['ok']}


def sdk_ok(m, f):
    """clang sdkflags/sdknowerror as phase_parity counts it: rc 0 and no survey category"""
    r = comp[m].get(f)
    if r is None:
        return None
    cats, _ = run.classify_llvm(r['rc'], run.read_log(W, m, f) or '')
    return r['rc'] == 0 and not cats

AREA_LABEL = {'rtos/other': 'rtos/other (tools, sfu)', 'at/CNN_Libraries': 'at/CNN_Libraries*',
              'examples/other': 'examples/isp etc.', 'utils': 'utils (ssbl, gap_cli)'}
AREA_ORDER = ['rtos/freertos', 'rtos/pmsis-implem', 'rtos/pmsis-bsp', 'rtos/other', 'libs/mbedtls',
              'libs/other', 'at/DSP_Libraries', 'at/CNN_Libraries', 'at/other-kernels',
              'audio-framework', 'examples/basic', 'examples/dsp', 'examples/nn', 'examples/audio',
              'examples/other', 'nn_menu', 'utils']


def errors(err):
    return [(msg, ctx) for sev, msg, ctx in run.diagnostics(err or '') if 'error' in sev]


def norm(msg):
    m = re.sub(r"'__builtin_pulp_\w+'", "'__builtin_pulp_X'", msg)
    m = re.sub(r"'[^']*'", lambda x: x.group(0) if 'builtin_pulp_X' in x.group(0) else "'X'", m)
    m = re.sub(r'\d+', 'N', m)
    return m[:140]


FP16_B = re.compile(r'^__builtin_pulp_(f16|v2hf|v2ohf|v2ah|v2h)')
FP32_B = re.compile(r'^__builtin_pulp_(f32|rintsf|fl1|flt|fcvt|f2)')


def group(msg, ctx):
    """one-line need group for an error message (strict or lenient)"""
    b = run.RX_BUILTIN.search(msg)
    if b:
        n = b.group(1)
        if n == '__builtin_shuffle':
            return '__builtin_shuffle'
        if FP16_B.match(n):
            return 'fp16 builtin (f16*/f16alt*)'
        if FP32_B.match(n):
            return 'fp32 builtin (f32*, rintsf2)'
        return 'other builtin'
    if re.search(r"(from|to|with an expression of) incompatible type 'int'|passing 'int' to "
                 r"parameter of incompatible type", msg):
        return 'cascade: int from an implicitly declared builtin used as a vector'
    if re.search(r'initializer element is not a compile-time constant', msg):
        return 'CoreCount() not constant in static initializer' if 'CoreCount' in ctx \
            else 'non-constant static initializer (other)'
    if re.search(r'must be a constant integer|argument (value|should be|to .* must be)|'
                 r'outside the valid range', msg):
        m = re.search(r"'(__builtin_pulp_\w+)'", msg + ctx)
        return 'non-constant builtin argument (Sema)'
    if re.search(r'call to undeclared (library )?function', msg):
        return 'clang-only implicit-declaration error'
    if re.search(r'float16|float_t|_Float16|__bf16|v2h|v2ah', msg):
        return 'float16 type / related'
    if re.search(r'incompatible (function )?pointer types|incompatible integer to pointer|'
                 r'incompatible pointer to integer|type specifier missing|should return a value|'
                 r'cast to smaller integer type', msg):
        return 'clang-stricter default error (other)'
    return 'other: ' + norm(msg)[:90]


def mode_row(f, strict, len_):
    rc = comp[strict][f]['rc']
    err = run.read_log(W, strict, f)
    cats, bl = run.classify_llvm(rc, err)
    ok = rc == 0 and not cats
    d = {'ok': ok, 'rc': rc}
    if ok:
        return d
    es = errors(err)
    d['first_error'] = es[0][0] if es else ((err or '').strip().splitlines() or ['rc=%s' % rc])[0][:200]
    d['first_group'] = group(*es[0]) if es else 'crash/other'
    d['categories'] = cats
    d['builtins_missing'] = sorted(bl)
    needs = {group(m, c) for m, c in es}
    bnames = set(bl)
    lerr = None
    if f in comp[len_]:
        lrc = comp[len_][f]['rc']
        lerr = run.read_log(W, len_, f)
        lcats, lbl = run.classify_llvm(lrc, lerr)
        for k in ('crash', 'timeout'):
            if k in lcats:
                cats[k] = lcats[k]
        rest = {k: v for k, v in lcats.items() if k != 'missing builtin'}
        d['lenient'] = ('ok' if lrc == 0 and not lcats else
                        'only-missing-builtins' if not rest else 'fail')
        d['lenient_categories'] = lcats
        needs |= {group(m, c) for m, c in errors(lerr)}
        # unknown builtins are warnings in lenient mode: still needs
        for sev, msg, ctx in run.diagnostics(lerr or ''):
            b = run.RX_BUILTIN.search(msg)
            if b:
                needs.add(group(msg, ctx))
        bnames |= set(lbl)
    for k in ('crash', 'timeout'):
        if k in cats:
            needs.add('%s: %s' % (k, cats[k][0][:100]))
    d['needs'] = sorted(needs)
    d['builtins_all'] = sorted(bnames)
    d['bucket'], d['detail'] = run.primary(cats)
    return d


rows = []
for e in inv:
    f = e['file']
    if e['scope'] != 'in' or comp['gcc'].get(f, {}).get('rc') != 0:
        continue
    r = {'file': f, 'area': e['area'], 'flag_source': e['flag_source'],
         'M1': f in m1ok, 'M2a_P': f in m2aP, 'M2a_X': f in m2aX, 'M2a_Q': f in m2aQ,
         'in_M1_set': f in m1files,
         'gcc_ok': True,   # the 617 are by definition GCC-ok without -Werror (survey gcc mode)
         'gccsdk_ok': comp['gccsdk'].get(f, {}).get('rc') == 0 if comp['gccsdk'] else None,
         'clang_sdkflags_ok': sdk_ok('sdkflags', f), 'clang_sdknowerror_ok': sdk_ok('sdknowerror', f)}
    r['P'] = mode_row(f, 'pe8', 'pe8lenient')
    r['X'] = mode_row(f, 'xgap9', 'xgap9lenient')
    r['Q'] = mode_row(f, 'pe8abs', 'pe8abslenient') if f in comp['pe8abs'] else {'ok': True, 'probe': 'not run (P ok)'}
    rows.append(r)

N = len(rows)
L = []
P = L.append
cnt = {c: sum(r[c]['ok'] for r in rows) for c in ('P', 'X', 'Q')}
nM1 = sum(r['M1'] for r in rows)
nP2 = sum(r['M2a_P'] for r in rows)
nX2 = sum(r['M2a_X'] for r in rows)
nW = sum(bool(r['gccsdk_ok']) for r in rows)
pW = sum(bool(r['gccsdk_ok']) and r['P']['ok'] for r in rows)
xW = sum(bool(r['gccsdk_ok']) and r['X']['ok'] for r in rows)
P('GCC-compilable files: %d (M1: 617; not in M1 set: %d)' % (N, sum(not r['in_M1_set'] for r in rows)))
P('P (-march=rv32imc_xgap9 -mPE=8): %d/%d = %.1f%%' % (cnt['P'], N, 100.0 * cnt['P'] / N))
P('X (-march=rv32imc_xgap9, no -mPE): %d/%d = %.1f%%' % (cnt['X'], N, 100.0 * cnt['X'] / N))
P('Q probe (P + f16abs2/f16altabs2 as elementwise abs): %d/%d = %.1f%%' % (cnt['Q'], N, 100.0 * cnt['Q'] / N))
P('M1 (config B): %d; M2a P: %d, M2a X: %d' % (nM1, nP2, nX2))
P('Denominator with the SDK -Werror flags (GCC gccsdk ok): %d; P ok among them: %d = %.1f%%; X: %d = %.1f%%'
  % (nW, pW, 100.0 * pW / (nW or 1), xW, 100.0 * xW / (nW or 1)))
nsf = sum(bool(r['clang_sdkflags_ok']) and bool(r['gccsdk_ok']) for r in rows)
nsn = sum(bool(r['clang_sdknowerror_ok']) for r in rows)
P('clang sdkflags mode (SDK -W flags incl. -Werror, run.py SDK_ARCH = xgap9 without -mPE): %d/%d; '
  'sdknowerror: %d/%d' % (nsf, nW, nsn, N))
P('')
area = collections.defaultdict(collections.Counter)
for r in rows:
    t = area[r['area']]
    t['gcc'] += 1
    t['M1'] += r['M1']
    t['M2aP'] += r['M2a_P']
    t['M2aX'] += r['M2a_X']
    t['gccW'] += bool(r['gccsdk_ok'])
    t['P'] += r['P']['ok']
    t['X'] += r['X']['ok']
P('| area | GCC ok | GCC -Werror ok | M1 | M2a P | P ok | P parity | P vs M2a | M2a X | X ok | X parity | X vs M2a |')
P('|' + '---|' * 12)
tot = collections.Counter()
pc = lambda a, b: '%.0f%%' % (100.0 * a / b) if b else '-'
for k in AREA_ORDER + sorted(set(area) - set(AREA_ORDER)):
    if k not in area:
        continue
    t = area[k]
    tot.update(t)
    P('| %s | %d | %d | %d | %d | %d | %s | %+d | %d | %d | %s | %+d |' % (
        AREA_LABEL.get(k, k), t['gcc'], t['gccW'], t['M1'], t['M2aP'], t['P'], pc(t['P'], t['gcc']),
        t['P'] - t['M2aP'], t['M2aX'], t['X'], pc(t['X'], t['gcc']), t['X'] - t['M2aX']))
t = tot
P('| **total** | **%d** | **%d** | **%d** | **%d** | **%d** | **%.1f%%** | **%+d** | **%d** | **%d** | **%.1f%%** | **%+d** |' % (
    t['gcc'], t['gccW'], t['M1'], t['M2aP'], t['P'], 100.0 * t['P'] / t['gcc'], t['P'] - t['M2aP'],
    t['M2aX'], t['X'], 100.0 * t['X'] / t['gcc'], t['X'] - t['M2aX']))

summary = {}
for cfg in ('P', 'X', 'Q'):
    fails = [r for r in rows if not r[cfg]['ok']]
    P('')
    P('== config %s: %d failures' % (cfg, len(fails)))
    P('-- survey primary bucket')
    bk = collections.Counter(r[cfg]['bucket'] for r in fails)
    for k, v in bk.most_common():
        P('  %4d  %s' % (v, k))
    P('-- first-error group (per file)')
    fg = collections.Counter(r[cfg]['first_group'] for r in fails)
    for k, v in fg.most_common():
        ar = collections.Counter(r['area'] for r in fails if r[cfg]['first_group'] == k)
        P('  %4d  %s   [%s]' % (v, k, ', '.join('%s %d' % x for x in ar.most_common())))
    P('-- first error per file (normalized)')
    fe = collections.Counter(norm(r[cfg]['first_error']) for r in fails)
    fex = {}
    for r in fails:
        fex.setdefault(norm(r[cfg]['first_error']), os.path.basename(r['file']))
    for k, v in fe.most_common(40):
        P('  %4d  %s   [e.g. %s]' % (v, k, fex[k]))
    P('-- all needs per file (strict + lenient errors)')
    need = collections.Counter(n for r in fails for n in r[cfg]['needs'])
    for k, v in need.most_common():
        P('  %4d  %s' % (v, k))
    P('-- files whose ONLY need is X')
    single = collections.Counter(r[cfg]['needs'][0] for r in fails if len(r[cfg]['needs']) == 1)
    for k, v in single.most_common():
        P('  %4d  %s' % (v, k))
    P('-- builtins missing (files, strict + lenient)')
    mb = collections.Counter(b for r in fails for b in r[cfg]['builtins_all'])
    P('  ' + ', '.join('%s %d' % (k.replace('__builtin_pulp_', ''), v) for k, v in mb.most_common()))
    P('-- non-constant builtin argument errors (which builtins)')
    nc = collections.Counter()
    for r in fails:
        for src in (r[cfg].get('categories', {}), r[cfg].get('lenient_categories', {})):
            for x in src.get('builtin argument check', []):
                nc[norm(x)] += 1
    for k, v in nc.most_common():
        P('  %4d  %s' % (v, k))
    P('-- clang-only implicit declarations (files)')
    for r in fails:
        if 'clang-only implicit-declaration error' in r[cfg]['needs']:
            P('  %s' % r['file'])
    P('-- "other" needs (files)')
    for r in fails:
        for n in r[cfg]['needs']:
            if n.startswith('other') or n.startswith('float16') or n.startswith('non-constant static'):
                P('  %s: %s' % (r['file'], n))
    newly_m1 = sorted(r['file'] for r in rows if r[cfg]['ok'] and not r['M1'])
    base = {'P': 'M2a_P', 'X': 'M2a_X', 'Q': 'M2a_Q'}[cfg]
    newly_f39 = sorted(r['file'] for r in rows if r[cfg]['ok'] and not r[base])
    reg_m1 = sorted(r['file'] for r in rows if not r[cfg]['ok'] and r['M1'])
    reg_f39 = sorted(r['file'] for r in rows if not r[cfg]['ok'] and r[base])
    crashes = sorted((r['file'], r[cfg]['bucket'], r[cfg]['detail'])
                     for r in fails if r[cfg]['bucket'] in ('crash', 'timeout'))
    P('-- crashes/hangs: %d' % len(crashes))
    for c in crashes:
        P('  %s: %s: %s' % c)
    P('-- regressions vs M1: %d; vs M2a: %d' % (len(reg_m1), len(reg_f39)))
    for f in sorted(set(reg_m1) | set(reg_f39)):
        P('  ' + f)
    P('-- newly compiling vs M2a: %d' % len(newly_f39))
    for f in newly_f39:
        P('  ' + f)
    summary[cfg] = {'ok': cnt[cfg], 'buckets': dict(bk), 'first_group': dict(fg.most_common()),
                    'first_error': dict(fe.most_common()), 'needs': dict(need.most_common()),
                    'single_need': dict(single.most_common()),
                    'missing_builtins': dict(mb.most_common()), 'newly_compiling_vs_M1': newly_m1,
                    'newly_compiling_vs_M2a': newly_f39, 'regressions_vs_M1': reg_m1,
                    'regressions_vs_M2a': reg_f39, 'crashes': crashes}

P('')
P('== P vs X differences')
diff = [(r['file'], r['P']['ok'], r['X']['ok']) for r in rows if r['P']['ok'] != r['X']['ok']]
for f, a, b in diff:
    P('  %s  P=%s X=%s' % (f, 'ok' if a else 'fail', 'ok' if b else 'fail'))
P('  (%d files differ)' % len(diff))
for cfg in ('P', 'X'):
    P('')
    P('== files that newly compile vs M1, config %s (%d)' % (cfg, len(summary[cfg]['newly_compiling_vs_M1'])))
    for f in summary[cfg]['newly_compiling_vs_M1']:
        P('  ' + f)

P('')
P('== P failures: GCC status (gcc = survey GCC mode, no -Werror; gccsdk = GCC with the SDK -Werror flags)')
for r in rows:
    if not r['P']['ok']:
        P('  %s  gcc=ok gccsdk=%s clang_sdkflags=%s clang_sdknowerror=%s  | %s' % (
            r['file'], 'ok' if r['gccsdk_ok'] else 'FAIL', r['clang_sdkflags_ok'], r['clang_sdknowerror_ok'],
            r['P']['first_error'][:120]))
P('-- GCC-ok files that GCC fails with the SDK -Werror flags (%d)' % (N - nW))
for r in rows:
    if not r['gccsdk_ok']:
        P('  %s  P=%s' % (r['file'], 'ok' if r['P']['ok'] else 'fail'))
open(OUT + '/analysis.txt', 'w').write('\n'.join(L) + '\n')
json.dump({'n_gcc_ok': N, 'n_gccsdk_ok': nW, 'P_ok_of_gccsdk': pW, 'X_ok_of_gccsdk': xW,
           'M1_ok': nM1, 'M2a_P_ok': nP2, 'M2a_X_ok': nX2, 'summary': summary, 'files': rows},
          open(OUT + '/results.part.json', 'w'), indent=1)
print('\n'.join(L[:30]))
