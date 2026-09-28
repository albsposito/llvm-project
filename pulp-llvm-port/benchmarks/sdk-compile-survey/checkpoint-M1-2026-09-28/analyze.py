#!/usr/bin/env python3
"""M1 checkpoint analysis: config A (strict: rv32imc_zfinx_xpulpv2 + macro shim)
and config B (xgap9: -march=rv32imc_xgap9, no shim) vs the 2026-09-28 baseline."""
import collections, json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import run

W = sys.argv[1]
OUT = sys.argv[2]
BASE = sys.argv[3]          # baseline results.json

inv = json.load(open(W + '/inventory.json'))
comp = {}
for m in ('gcc', 'strict', 'lenient', 'xgap9', 'xgap9lenient'):
    p = '%s/compile_%s.json' % (W, m)
    comp[m] = json.load(open(p)) if os.path.exists(p) else {}
base = {r['file']: r for r in json.load(open(BASE))}

AREA_LABEL = {'rtos/other': 'rtos/other (tools, sfu)', 'at/CNN_Libraries': 'at/CNN_Libraries*',
              'examples/other': 'examples/isp etc.', 'utils': 'utils (ssbl, gap_cli)'}
AREA_ORDER = ['rtos/freertos', 'rtos/pmsis-implem', 'rtos/pmsis-bsp', 'rtos/other', 'libs/mbedtls',
              'libs/other', 'at/DSP_Libraries', 'at/CNN_Libraries', 'at/other-kernels',
              'audio-framework', 'examples/basic', 'examples/dsp', 'examples/nn', 'examples/audio',
              'examples/other', 'nn_menu', 'utils']


def first_error(err):
    for sev, msg, ctx in run.diagnostics(err or ''):
        if 'error' in sev:
            return msg
    return None


def norm(msg):
    m = re.sub(r"'[^']*'", "'X'", msg)
    m = re.sub(r'\d+', 'N', m)
    return m[:140]


def mode_row(f, strict, len_):
    rc = comp[strict][f]['rc']
    err = run.read_log(W, strict, f)
    cats, bl = run.classify_llvm(rc, err)
    ok = rc == 0 and not cats
    d = {'ok': ok, 'rc': rc}
    if not ok:
        d['first_error'] = first_error(err)
        if d['first_error'] is None:
            lines = [l for l in (err or '').splitlines() if l.strip()]
            d['first_error'] = lines[0][:200] if lines else 'rc=%s' % rc
        d['categories'] = cats
        d['builtins_missing'] = sorted(bl)
        if f in comp[len_]:
            lrc = comp[len_][f]['rc']
            lcats, lbl = run.classify_llvm(lrc, run.read_log(W, len_, f))
            for k in ('crash', 'timeout'):
                if k in lcats:
                    cats[k] = lcats[k]
            rest = {k: v for k, v in lcats.items() if k != 'missing builtin'}
            d['lenient'] = ('ok' if lrc == 0 and not lcats else
                            'only-missing-builtins' if not rest else 'fail')
            d['lenient_categories'] = lcats
            d['lenient_builtins_missing'] = sorted(lbl)
        d['bucket'], d['detail'] = run.primary(cats)
    return d


rows = []
for e in inv:
    f = e['file']
    if e['scope'] != 'in' or comp['gcc'].get(f, {}).get('rc') != 0:
        continue
    r = {'file': f, 'area': e['area'], 'flag_source': e['flag_source'],
         'baseline': base.get(f, {}).get('llvm', 'n/a (not GCC-ok in baseline)')}
    r['A'] = mode_row(f, 'strict', 'lenient')
    r['B'] = mode_row(f, 'xgap9', 'xgap9lenient')
    rows.append(r)

N = len(rows)
nA = sum(r['A']['ok'] for r in rows)
nB = sum(r['B']['ok'] for r in rows)
nBase = sum(r['baseline'] == 'ok' for r in rows)
L = []
P = L.append
P('GCC-compilable files: %d (baseline 617; baseline ok among them %d)' % (N, nBase))
P('A strict (rv32imc_zfinx_xpulpv2 + shim): %d/%d = %.1f%%' % (nA, N, 100.0 * nA / N))
P('B xgap9  (rv32imc_xgap9, no shim):       %d/%d = %.1f%%' % (nB, N, 100.0 * nB / N))
P('')
area = collections.defaultdict(collections.Counter)
for r in rows:
    t = area[r['area']]
    t['gcc'] += 1
    t['base'] += r['baseline'] == 'ok'
    t['A'] += r['A']['ok']
    t['B'] += r['B']['ok']
hdr = '| area | GCC ok | baseline | A ok | A parity | delta A | B ok | B parity | delta B |'
P(hdr)
P('|' + '---|' * 9)
tot = collections.Counter()
pc = lambda a, b: '%.0f%%' % (100.0 * a / b) if b else '-'
for k in AREA_ORDER + sorted(set(area) - set(AREA_ORDER)):
    if k not in area:
        continue
    t = area[k]
    tot.update(t)
    P('| %s | %d | %d | %d | %s | %+d | %d | %s | %+d |' % (
        AREA_LABEL.get(k, k), t['gcc'], t['base'], t['A'], pc(t['A'], t['gcc']), t['A'] - t['base'],
        t['B'], pc(t['B'], t['gcc']), t['B'] - t['base']))
t = tot
P('| **total** | **%d** | **%d** | **%d** | **%s** | **%+d** | **%d** | **%s** | **%+d** |' % (
    t['gcc'], t['base'], t['A'], '%.1f%%' % (100.0 * t['A'] / t['gcc']), t['A'] - t['base'],
    t['B'], '%.1f%%' % (100.0 * t['B'] / t['gcc']), t['B'] - t['base']))

summary = {}
for cfg in ('A', 'B'):
    fails = [r for r in rows if not r[cfg]['ok']]
    P('')
    P('== config %s: %d failures' % (cfg, len(fails)))
    P('-- primary bucket (order crash > timeout > option > builtin > type > gcc-only > asm > '
      'argcheck > stricter > header > other)')
    bk = collections.Counter(r[cfg]['bucket'] for r in fails)
    ex = {}
    for r in fails:
        ex.setdefault(r[cfg]['bucket'], r['file'])
    for k, v in bk.most_common():
        P('  %4d  %-30s e.g. %s' % (v, k, ex[k]))
    P('-- primary bucket detail')
    bd = collections.Counter((r[cfg]['bucket'], r[cfg]['detail'][:110]) for r in fails)
    for (k, d), v in bd.most_common(40):
        P('  %4d  %s: %s' % (v, k, d))
    P('-- first error per file (normalized)')
    fe = collections.Counter(norm(r[cfg]['first_error']) for r in fails)
    fex = {}
    for r in fails:
        fex.setdefault(norm(r[cfg]['first_error']), r['file'])
    for k, v in fe.most_common(40):
        P('  %4d  %s   [e.g. %s]' % (v, k, fex[k]))
    P('-- files needing each item (any category, strict + lenient)')
    need = collections.Counter()
    for r in fails:
        items = run.items_of(r[cfg]['categories']) | run.items_of(r[cfg].get('lenient_categories', {}))
        need.update(items)
    for k, v in need.most_common(40):
        P('  %4d  %s' % (v, k[:150]))
    P('-- missing builtins (files failing on each, strict)')
    mb = collections.Counter(b for r in fails for b in r[cfg]['builtins_missing'])
    for k, v in mb.most_common(40):
        P('  %4d  %s' % (v, k))
    newly = sorted(r['file'] for r in rows if r[cfg]['ok'] and r['baseline'] != 'ok')
    regressed = sorted(r['file'] for r in rows if not r[cfg]['ok'] and r['baseline'] == 'ok')
    crashes = sorted((r['file'], r[cfg]['bucket'], r[cfg]['detail'])
                     for r in fails if r[cfg]['bucket'] in ('crash', 'timeout'))
    P('-- crashes/hangs: %d' % len(crashes))
    for c in crashes:
        P('  %s: %s: %s' % c)
    P('-- regressions vs baseline: %d' % len(regressed))
    for f in regressed:
        P('  ' + f)
    summary[cfg] = {'ok': sum(r[cfg]['ok'] for r in rows), 'buckets': dict(bk),
                    'first_error': dict(fe.most_common()), 'needs': dict(need.most_common()),
                    'missing_builtins': dict(mb.most_common()), 'newly_compiling': newly,
                    'regressions': regressed, 'crashes': crashes}

P('')
P('== A vs B differences')
diff = [(r['file'], r['A']['ok'], r['B']['ok']) for r in rows if r['A']['ok'] != r['B']['ok']]
for f, a, b in diff:
    P('  %s  A=%s B=%s' % (f, 'ok' if a else 'fail', 'ok' if b else 'fail'))
P('  (%d files differ)' % len(diff))
for cfg in ('A', 'B'):
    P('')
    P('== files that newly compile, config %s (%d)' % (cfg, len(summary[cfg]['newly_compiling'])))
    for f in summary[cfg]['newly_compiling']:
        P('  ' + f)

open(OUT + '/analysis.txt', 'w').write('\n'.join(L) + '\n')
json.dump({'n_gcc_ok': N, 'baseline_ok': nBase, 'summary': summary, 'files': rows},
          open(OUT + '/results.json', 'w'), indent=1)
print('\n'.join(L[:40]))
