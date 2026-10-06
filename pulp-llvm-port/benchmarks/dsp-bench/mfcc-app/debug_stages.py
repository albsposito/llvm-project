#!/usr/bin/env python3
"""Localise a numerical difference: dump every stage output of one frame from the clang build,
the GCC build (both on GVSoC) and the host build, and compare them stage by stage, against each
other and against the float64 numpy reference.

  /home/ubuntu/gvsoc-venv/bin/python debug_stages.py <config> <frame> [opt]     (needs numpy)

Debug builds go to build/dbg-<config>-f<frame>/; they are not timed.
"""
import collections, re, struct, sys
import numpy as np
import run, ref_mfcc

config, frame = sys.argv[1], int(sys.argv[2])
opt = sys.argv[3] if len(sys.argv) > 3 else 'O2'
name = f'dbg-{config}-f{frame}'
run.CONFIGS[name] = dict(run.CONFIGS[config], defs=run.CONFIGS[config]['defs'] + [f'-DMFCC_DUMP_FRAME={frame}'])
variant = run.CONFIGS[config]['variant']
HEXD = re.compile(r'^HEXD (\S+) (\d+) (0x[0-9a-f]+)', re.M)


def dec(stage, u):
    if variant == 'fix16':
        if stage in ('spec', 'mel'):
            return float(u)
        return float(struct.unpack('<h', struct.pack('<H', u & 0xffff))[0])
    return run.decode(variant, u)


def grab(text):
    d = collections.defaultdict(list)
    for st, i, u in HEXD.findall(text):
        d[st].append(dec(st, int(u, 16)))
    return {k: np.array(v) for k, v in d.items()}


outs = {}
for cc in ('clang', 'gcc'):
    row = run.build(name, cc, opt)
    if row['status'] != 'built':
        print(cc, row['status'], row['reason']); continue
    row = run.simulate(row)
    outs[cc] = grab((run.R / 'build' / name / cc / opt / 'sim.log').read_text())
h = run.host_ref(name)
if h['status'] == 'ok':
    outs['host'] = grab((run.R / 'build/host' / name / 'run.log').read_text())
else:
    print('host', h)
ref = ref_mfcc.stages()
REFKEY = {'pre': 'pre', 'win': 'win', 'spec': 'pow', 'mel': 'mel', 'log': 'log', 'dct': 'mfcc'}


def snr(a, b):
    n = min(len(a), len(b)); a, b = a[:n], b[:n]
    m = np.isfinite(a) & np.isfinite(b)
    e = ((a[m] - b[m]) ** 2).sum()
    return 'identical' if e == 0 and m.all() else f'{10 * np.log10((b[m] ** 2).sum() / e):6.1f} dB (max |d| {abs(a[m] - b[m]).max():.4g}, nonfinite {int((~m).sum())})'


names = list(outs)
for st in ('pre', 'win', 'fft', 'spec', 'mel', 'log', 'dct'):
    print(f'--- {st}')
    for i, a in enumerate(names):
        for b in names[i + 1:]:
            print(f'  {a:5s} vs {b:5s}: {snr(outs[a][st], outs[b][st])}')
        if st in REFKEY and variant != 'fix16' or st in ('log', 'dct'):
            r = ref[REFKEY[st]][frame] * (32.0 if variant == 'fix16' else 1.0)
            print(f'  {a:5s} vs numpy: {snr(outs[a][st], r)}')
np.save(run.R / 'build' / name / 'stages.npy', outs, allow_pickle=True)
