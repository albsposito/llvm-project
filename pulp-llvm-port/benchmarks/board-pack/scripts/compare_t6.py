#!/usr/bin/env python3
"""Compare test-6 runs: cycles per kernel call, clang vs GCC, per core.
   scripts/compare_t6.py <log> [<log> ...]
Reads the "RESULT t6 core=.. lib=.. kernel=.. cycles=.. checksum=.." lines of any number of
run logs (each log normally holds one library: gcc-O2, gcc-O3, clang-O2 or clang-O3) and prints,
for each core and optimisation level, the clang/gcc cycle ratio per kernel and the geomean."""
import math, re, sys, collections
R = re.compile(r'^RESULT t6 core=(\w+) lib=(\w+)-(O\d) kernel=(\S+) cycles=(\d+) instrs=(\d+) checksum=(0x[0-9a-f]+)')
import os
d = collections.defaultdict(dict)          # (set, core, opt) -> {(cc, kernel): (cycles, checksum)}
for f in sys.argv[1:]:
    st = 'prebuilt ELFs' if os.path.basename(f).startswith('prebuilt.') else 'built here'
    for line in open(f, errors='replace'):
        m = R.match(line.strip())
        if m:
            core, cc, opt, k, cyc, ins, cks = m.groups()
            d[(st, core, opt)][(cc, k)] = (int(cyc), cks)
if not d:
    sys.exit('no "RESULT t6" lines found')
for (st, core, opt) in sorted(d, key=lambda x: (x[0], x[1] != 'fc', x[2])):
    t = d[(st, core, opt)]
    ks = sorted({k for _, k in t}, key=lambda k: [kk for _, kk in t].index(k))
    print(f'\n## {st}: core={core} -{opt}   (cycles per call; ratio = clang/gcc, < 1 means clang is faster)')
    print(f'{"kernel":26s} {"gcc":>9s} {"clang":>9s} {"ratio":>7s}  checksums')
    logs = []
    for k in ks:
        g, c = t.get(('gcc', k)), t.get(('clang', k))
        ratio = f'{c[0] / g[0]:.3f}' if g and c else '-'
        if g and c: logs.append(math.log(c[0] / g[0]))
        same = 'same' if g and c and g[1] == c[1] else ('DIFFERENT' if g and c else '')
        print(f'{k:26s} {g[0] if g else "-":>9} {c[0] if c else "-":>9} {ratio:>7s}  {same}')
    if logs:
        print(f'{"geomean clang/gcc":26s} {"":9s} {"":9s} {math.exp(sum(logs) / len(logs)):7.3f}  ({len(logs)} kernels)')
