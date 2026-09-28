#!/usr/bin/env python3
"""Summarise ladder.tsv: per app, GCC vs clang variants (build, link, run, output).

Output comparison is order-insensitive (cluster cores print in a
timing-dependent order) and ignores numbers on lines that report cycles,
time or GVSoC timestamps (those differ between compilers by design).

  compare.py [ladder.tsv] [--md]
"""
import collections, os, re, sys

W = os.environ.get('SDK_CLANG_WORK', '/tmp/sdk-clang-work')
args = [a for a in sys.argv[1:] if not a.startswith('--')]
md = '--md' in sys.argv
tsv = args[0] if args else os.path.join(W, 'ladder.tsv')

rows = collections.OrderedDict()
for line in open(tsv):
    p = line.rstrip('\n').split('\t')
    if len(p) < 6:
        continue
    app, var, brc, elf, rrc, h = p[:6]
    rows.setdefault(app, {})[var] = dict(brc=brc, elf=elf == 'yes', rrc=rrc)

NUM = re.compile(r'\d+')
VOLATILE = re.compile(r'cycle|time|Timer|Perf|pc: 0x|^\d+: \d+:|elapsed|MHz|Hz|0x[0-9a-f]{6,}', re.I)


def norm(path):
    try:
        lines = open(path, errors='replace').read().splitlines()
    except OSError:
        return None
    out = []
    for l in lines:
        if l.startswith('[run_app]') or not l.strip():
            continue
        if VOLATILE.search(l):
            l = NUM.sub('N', re.sub(r'0x[0-9a-fA-F]+', 'H', l))
        out.append(l.rstrip())
    return sorted(out)


def run_file(app, var):
    return os.path.join(W, 'bld', app.replace('/', '_') + '__' + var, 'run.out')


def cell(app, var, ref):
    r = rows[app].get(var)
    if r is None:
        return 'n/a'
    if r['brc'] != '0' and not r['elf']:
        return 'build FAIL'
    if not r['elf']:
        return 'no ELF'
    s = 'run rc=%s' % r['rrc']
    if var != 'gcc' and ref is not None:
        o = norm(run_file(app, var))
        s += ' same-as-gcc' if o == ref else ' DIFFERS'
    return s


variants = []
for app in rows:
    for v in rows[app]:
        if v not in variants:
            variants.append(v)
variants.sort(key=lambda v: (v != 'gcc', v))

counts = collections.Counter()
lines = []
for app in rows:
    ref = norm(run_file(app, 'gcc')) if 'gcc' in rows[app] else None
    cells = [cell(app, v, ref) for v in variants]
    for v, c in zip(variants, cells):
        counts[(v, c)] += 1
    lines.append([app.replace('examples/gap9/', '')] + cells)

if md:
    print('| app | ' + ' | '.join(variants) + ' |')
    print('|---' * (len(variants) + 1) + '|')
    for l in lines:
        print('| ' + ' | '.join(l) + ' |')
else:
    for l in lines:
        print('\t'.join(l))
print()
for v in variants:
    tot = collections.Counter({c: n for (vv, c), n in counts.items() if vv == v})
    print('%-45s %s' % (v, ', '.join('%s: %d' % kv for kv in sorted(tot.items()))))
