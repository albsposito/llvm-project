#!/usr/bin/env python3
"""Per-function summary of an assembly file: packed-SIMD mnemonics, hardware
loops, post-increment accesses, instruction count.
  asm_table.py [--md] file.s [file2.s ...]
With several files the packed columns are printed side by side (same function
order as the first file)."""
import re, sys, collections

PACKED = re.compile(r'^(pv\.|vf)')


def parse(path):
    funcs = collections.OrderedDict()
    cur = None
    for line in open(path):
        m = re.match(r'^([A-Za-z_][\w$]*):', line)
        if m and not m.group(1).startswith(('.L', 'L')):
            cur = m.group(1); funcs[cur] = []; continue
        if cur is None:
            continue
        s = line.split('#')[0].strip()
        if not s or s.startswith('.') or s.endswith(':'):
            continue
        funcs[cur].append(s)
    return funcs


def summ(ins):
    mn = [i.split()[0] for i in ins]
    packed = collections.Counter(m for m in mn if PACKED.match(m))
    hw = sum(1 for m in mn if m.startswith('lp.'))
    # post-increment: GNU syntax "p.lh a5,2(a1!)", LLVM syntax "p.lh a5, 2(a1!)"
    post = sum(1 for i in ins if '!' in i)
    br = sum(1 for m in mn if re.match(r'^(c\.)?(b[a-z]+|j|jal|p\.b[a-z]+imm)$', m))
    calls = sorted({i.split()[-1] for i in ins if re.match(r'^(call|tail)\b', i)})
    return dict(n=len(ins), packed=' '.join(f'{k}x{v}' for k, v in sorted(packed.items())) or '-',
                hw=hw, post=post, br=br, calls=' '.join(calls))


md = '--md' in sys.argv
files = [a for a in sys.argv[1:] if not a.startswith('--')]
tabs = [parse(f) for f in files]
names = list(tabs[0].keys())
hdr = ['function']
for f in files:
    tag = f.split('/')[-1].replace('.s', '')
    hdr += [f'{tag}: packed', 'insns', 'hwloops', 'post-inc']
rows = []
for n in names:
    if n not in tabs[0] or not tabs[0][n]:
        continue
    r = [n]
    for t in tabs:
        if n in t:
            s = summ(t[n]); r += [s['packed'], str(s['n']), str(s['hw']), str(s['post'])]
        else:
            r += ['?', '?', '?', '?']
    rows.append(r)
if md:
    print('| ' + ' | '.join(hdr) + ' |'); print('|' + '---|' * len(hdr))
    for r in rows: print('| ' + ' | '.join(r) + ' |')
else:
    for r in [hdr] + rows: print('\t'.join(r))
