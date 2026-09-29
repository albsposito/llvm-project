"""Combined 'all needs' per P-failing file: P strict+lenient, plus what the
f16abs2 probe (Q) uncovers behind the silenced implicit declarations; greedy order."""
import collections, json, re, sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import run
W, OUT = sys.argv[1:3]
d = json.load(open(OUT + '/results.part.json'))
FP16 = re.compile(r'^__builtin_pulp_(f16|v2hf|v2ohf)')
FP32 = re.compile(r'^__builtin_pulp_(f32|rintsf)')
def bgroup(n):
    if n in ('__builtin_pulp_f16abs2', '__builtin_pulp_f16altabs2'):
        return 'f16abs2/f16altabs2 (implicit decl silenced by a pragma in FastFloatApprox16.h)'
    if FP16.match(n): return 'fp16 builtins (f16*/f16alt* max/min/max2/min2/sqrt, v2hf<->v2ohf)'
    if FP32.match(n): return 'fp32 builtins (f32max/min/abs/sqrt, rintsf2)'
    return 'other builtins (%s)' % n.replace('__builtin_pulp_', '')
def items(f, mode):
    out = set()
    for m in (mode, mode + 'lenient'):
        err = run.read_log(W, m, f)
        if err is None: continue
        for sev, msg, ctx in run.diagnostics(err):
            b = run.RX_BUILTIN.search(msg)
            if b: out.add(bgroup(b.group(1))); continue
            if sev == 'warning': continue
            if re.search(r"(from|to|with an expression of) incompatible type 'int'|passing 'int' to parameter of incompatible type", msg):
                ns = set(re.findall(r'__builtin_pulp_\w+', ctx))
                if not ns and re.search(r'M(ax|in)v2a?h', ctx):
                    ns = {'__builtin_pulp_f16max2'}   # Maxv2h/Minv2h/Maxv2ah/Minv2ah -> f16(alt)max2/min2
                for n in ns or {'?'}:
                    out.add(bgroup(n) if n != '?' else 'cascade (unknown builtin)')
            elif 'must be a constant integer' in msg:
                out.add('non-constant mulsN/clip/clipu argument (Sema)')
            elif 'call to undeclared' in msg or 'incompatible integer to pointer' in msg:
                out.add('clang-only implicit-declaration error (-Wno-error flag)')
            elif "couldn't allocate" in msg:
                out.add("inline asm: 32-bit SIMD vector (v2s/v2h/v2ah) in an 'r' operand")
            elif 'initializer element is not a compile-time constant' in msg:
                out.add('CoreCount() constant (-mPE)')
            else:
                out.add('other: ' + msg[:100])
    return out
comb = {}
for r in d['files']:
    if r['P']['ok']: continue
    n = items(r['file'], 'pe8')
    if r['file'] in json.load(open(W + '/compile_pe8abs.json')):
        n |= items(r['file'], 'pe8abs')
    if r['file'].endswith('CNN_Libraries_SQ8/CNN_Pooling_SQ8.c'):
        # manual probe (Q flags + f16max/min(2) as elementwise max/min): 8 inline-asm errors at 4539..4798
        n.add("inline asm: 32-bit SIMD vector (v2s/v2h/v2ah) in an 'r' operand")
    comb[r['file']] = sorted(n)
    r['P']['needs_combined'] = sorted(n)
cnt = collections.Counter(i for n in comb.values() for i in n)
fail = [set(n) for n in comb.values()]
chosen, done, steps = set(), 0, []
base = sum(r['P']['ok'] for r in d['files'])
while True:
    best, bg = None, 0
    for it in sorted(cnt):
        if it in chosen: continue
        g = sum(1 for n in fail if not n <= chosen and n <= chosen | {it})
        if g > bg or (g == bg and g and cnt[it] > cnt[best]): best, bg = it, g
    if not best: break
    chosen.add(best); done += bg
    steps.append({'fix': best, 'files_unlocked': bg, 'cumulative_ok': base + done, 'files_needing': cnt[best]})
left = [n for n in fail if not n <= chosen]
d['P_needs_combined_counts'] = cnt.most_common()
d['P_greedy'] = steps
d['P_single_blocker'] = collections.Counter(next(iter(n)) for n in fail if len(n) == 1).most_common()
json.dump(d, open(OUT + '/results.part.json', 'w'), indent=1)
print('needs (files):'); [print('  %3d  %s' % (v, k)) for k, v in cnt.most_common()]
print('single blocker:'); [print('  %3d  %s' % (v, k)) for k, v in d['P_single_blocker']]
print('greedy (base %d):' % base)
for s in steps: print('  +%-3d -> %d  %.1f%%  %s (needed by %d)' % (s['files_unlocked'], s['cumulative_ok'], 100.0*s['cumulative_ok']/617, s['fix'], s['files_needing']))
print('never unlocked:', len(left))
