#!/usr/bin/env python3
"""(Copy of benchmarks/gap9-sweep/runtime/pc_profile.py; only the objdump path and its --mattr
were changed so that GAP9 f16 instructions are decoded.)

Per-PC execution profile of one ELF on GVSoC (instruction trace), for regression analysis.

  python3 pc_profile.py build/port19/O2/k05_matmul_dsp_fix16/prog.elf [function] [--top N]

Runs gvrun with --trace=insn, counts executions and cycle deltas (timestamp difference to the next
traced instruction) per PC, and prints the hottest PCs of `function` (default: all) with the
disassembly line. Cycle attribution is approximate (stalls are charged to the instruction that
precedes them in the trace)."""
import collections, pathlib, re, subprocess, sys, tempfile, os
R = pathlib.Path(__file__).resolve().parent
TC = R.parent.parent.parent / 'toolchains/port-20-bench/bin'
elf = pathlib.Path(sys.argv[1]).resolve()
func = sys.argv[2] if len(sys.argv) > 2 and not sys.argv[2].startswith('--') else None
top = int(sys.argv[sys.argv.index('--top') + 1]) if '--top' in sys.argv else 40
with tempfile.TemporaryDirectory() as w:
    tr = pathlib.Path(w) / 'insn.trace'
    env = dict(os.environ, USE_GVRUN='1', USE_GVRUN2='1', PATH='/home/ubuntu/gvsoc-venv/bin:' + os.environ['PATH'])
    env.pop('PYTHONPATH', None)
    subprocess.run(['/home/ubuntu/gap_sdk_release/install/gvsoc2/bin/gvrun', '--target=ri5ky_testbench', f'--work-dir={w}',
                    '--parameter', f'soc/binary={elf}', f'--trace=insn:{tr}', 'run'], env=env, capture_output=True)
    cnt, cyc = collections.Counter(), collections.Counter()
    prev = None
    pat = re.compile(r'^(\d+): (\d+): .*?\] M ([0-9a-f]{8}) ')
    with open(tr, errors='replace') as f:
        for line in f:
            m = pat.match(line)
            if not m:
                continue
            c, pc = int(m.group(2)), int(m.group(3), 16)
            cnt[pc] += 1
            if prev:
                cyc[prev[1]] += c - prev[0]
            prev = (c, pc)
dis = subprocess.run([TC / 'llvm-objdump', '-d', '--mattr=+m,+c,+zfinx,+zhinx,+xgap,+xpulpv,+xpulpf16alt,+xpulpfvec', elf], text=True, capture_output=True).stdout
text, owner, cur = {}, {}, None
for l in dis.splitlines():
    m = re.match(r'^([0-9a-f]+) <(.+)>:$', l)
    if m:
        cur = m.group(2); continue
    m = re.match(r'^\s*([0-9a-f]+):\s+(?:[0-9a-f]{2,8}\s)+\s*(.*)$', l)
    if m and cur:
        text[int(m.group(1), 16)] = m.group(2).strip(); owner[int(m.group(1), 16)] = cur
per_f = collections.Counter(); per_fc = collections.Counter()
for pc, n in cnt.items():
    per_f[owner.get(pc, '?')] += n; per_fc[owner.get(pc, '?')] += cyc[pc]
print('function                          instrs     cycles')
for f, n in per_f.most_common(10):
    print(f'{f:30s} {n:9d} {per_fc[f]:10d}')
sel = [pc for pc in cnt if func is None or owner.get(pc) == func]
print(f'\nhottest PCs{" in " + func if func else ""} (count, cycles, pc, insn):')
for pc in sorted(sorted(sel, key=lambda p: -cnt[p])[:top]):
    print(f'{cnt[pc]:8d} {cyc[pc]:8d}  {pc:06x}  {text.get(pc, "?")}')
