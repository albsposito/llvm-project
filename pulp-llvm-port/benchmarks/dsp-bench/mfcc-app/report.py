#!/usr/bin/env python3
"""Builds report.md from results.json (tables) and report_text.md (hand-written sections).

report_text.md is split on lines of the form '<!-- TABLES -->': the generated tables go there.
"""
import json, pathlib

R = pathlib.Path(__file__).resolve().parent
d = json.loads((R / 'results.json').read_text())
rows, meta = d['rows'], d['meta']
STAGES = meta['stages']
MHZ = meta['assumed_mhz']
APP_FUNCS = {'main', '_start', 'memcpy', 'memset', 'load_frame', 'put_frame', 'st_hash', 'hexdump'}
out = []


def get(config, cc, opt):
    return next((r for r in rows if r['config'] == config and r['compiler'] == cc and r['opt'] == opt), None)


def ran(r):
    return r is not None and r['status'] == 'ran'


def ratio(a, b, f='{:.3f}'):
    return f.format(a / b) if a and b else '-'


def fail(r):
    if r is None:
        return 'not built'
    u = r.get('undefined')
    if r['status'] == 'link-fail' and u:
        tag = {'__truncsfbf2': 'B133', '__builtin_pulp_v2hitov2hf_u': 'B149'}
        return 'does not link: ' + ', '.join(f'`{x}` ({tag.get(x, "?")})' for x in u)
    return r['status']


configs = []
for r in rows:
    if r['config'] not in configs:
        configs.append(r['config'])
MAIN = [c for c in configs if c in ('fix16', 'f32', 'f16', 'f16a')]
EXP = [c for c in configs if c not in MAIN]

# ---- 1. status + headline ----
out.append('### Table 1. Cycles per frame, clang vs GCC\n')
out.append('One frame = 512 samples in, 13 MFCCs out. Mean over the 96 frames of the clip. "ratio" is clang / GCC; below 1 means clang is faster.\n')
out.append('| configuration | opt | clang cycles | GCC cycles | ratio | clang instrs | GCC instrs | ratio |')
out.append('|---|---|---:|---:|---:|---:|---:|---:|')
for c in configs:
    for o in ('O2', 'O3', 'Os'):
        a, b = get(c, 'clang', o), get(c, 'gcc', o)
        if c == 'f16a+logf32+rt':
            b = get('f16a+logf32', 'gcc', o)
        ca = f'{a["cycles_per_frame"]:.0f}' if ran(a) else fail(a)
        cb = f'{b["cycles_per_frame"]:.0f}' if ran(b) else fail(b)
        ia = f'{a["instrs_per_frame"]:.0f}' if ran(a) else '-'
        ib = f'{b["instrs_per_frame"]:.0f}' if ran(b) else '-'
        rc = ratio(a['cycles_per_frame'], b['cycles_per_frame']) if ran(a) and ran(b) else '-'
        ri = ratio(a['instrs_per_frame'], b['instrs_per_frame']) if ran(a) and ran(b) else '-'
        out.append(f'| {c} | {o} | {ca} | {cb} | {rc} | {ia} | {ib} | {ri} |')
out.append('')
out.append('Configurations other than fix16, f32, f16 and f16a are labelled experiments:\n')
for c in EXP:
    out.append(f'- **{c}**: {next(r["experiment"] for r in rows if r["config"] == c)}.'
               + (' The GCC column is the f16a+logf32 GCC build.' if c == 'f16a+logf32+rt' else ''))
out.append('')

# ---- 2. correctness ----
out.append('### Table 2. Correctness (O2; O3 and Os give the same MFCC bits as O2 for every compiler and configuration)\n')
same = all(ran(get(c, cc, o)) == ran(get(c, cc, 'O2')) and (not ran(get(c, cc, o)) or get(c, cc, o)['checksum'] == get(c, cc, 'O2')['checksum'])
           for c in configs for cc in ('clang', 'gcc') for o in ('O3', 'Os') if get(c, cc, 'O2'))
if not same:
    out.append('**NOTE: at least one O3/Os build differs from its O2 build; see results.json.**\n')
out.append('SNR and correlation are over all 96 x 13 output values. "numpy ref" is the float64 reference (ref_mfcc.py).\n')
out.append('| configuration | compiler | MFCC checksum | vs GCC O2 | first stage that differs from GCC | vs host build | SNR vs numpy ref (dB) | corr vs numpy ref |')
out.append('|---|---|---|---|---|---|---:|---:|')


def cmpstr(r, key, exact):
    if exact not in r:
        return '-'
    if r[exact]:
        return 'bit-exact'
    v = r[key]
    return f'{v["differing"]}/{v["n"]} values differ, SNR {v["snr_db"]} dB, max diff {v["max_abs_diff"]:.3g}'


for c in configs:
    for cc in ('clang', 'gcc'):
        r = get(c, cc, 'O2')
        if r is None:
            continue
        if not ran(r):
            out.append(f'| {c} | {cc} | {fail(r)} | - | - | - | - | - |')
            continue
        v = r.get('vs_numpy_ref', {})
        out.append(f'| {c} | {cc} | {r["checksum"]} | {cmpstr(r, "vs_gcc_O2", "bit_exact_vs_gcc_O2") if cc == "clang" else "(reference)"} | '
                   f'{r.get("first_diverging_stage_vs_gcc_O2") or "-"} | {cmpstr(r, "vs_host", "bit_exact_vs_host")} | '
                   f'{v.get("snr_db", "-")} | {v.get("corr", "-")} |')
out.append('')
out.append('Host build (x86-64 gcc -O0, the same C sources) against the numpy reference:\n')
out.append('| variant | SNR (dB) | correlation | max abs diff |')
out.append('|---|---:|---:|---:|')
for v, h in meta['host_vs_numpy_ref'].items():
    out.append(f'| {v} | {h["snr_db"]} | {h["corr"]} | {h["max_abs_diff"]:.3g} |')
out.append('')

# ---- 3. per stage ----
out.append('### Table 3. Cycles per frame by stage\n')
for o in ('O2', 'O3'):
    out.append(f'**-{o}** (clang / GCC / ratio)\n')
    cs = [c for c in configs if ran(get(c, 'clang', o)) and (ran(get(c, 'gcc', o)) or c == 'f16a+logf32+rt')]
    out.append('| stage | ' + ' | '.join(cs) + ' |')
    out.append('|---|' + '---|' * len(cs))
    for s in STAGES + ['total']:
        cells = []
        for c in cs:
            a = get(c, 'clang', o)
            b = get('f16a+logf32' if c == 'f16a+logf32+rt' else c, 'gcc', o)
            x = a['cycles_per_frame'] if s == 'total' else a['stages'][s]['cycles_per_frame']
            y = b['cycles_per_frame'] if s == 'total' else b['stages'][s]['cycles_per_frame']
            cells.append(f'{x:.0f} / {y:.0f} / **{x / y:.2f}**')
        out.append(f'| {s} | ' + ' | '.join(cells) + ' |')
    out.append('')
out.append('GCC-only variants (clang does not link them), cycles per frame by stage at -O2 / -O3:\n')
gs = [c for c in ('f16', 'f16a', 'f16a+logf32') if ran(get(c, 'gcc', 'O2'))]
out.append('| stage | ' + ' | '.join(gs) + ' |')
out.append('|---|' + '---|' * len(gs))
for s in STAGES + ['total']:
    cells = []
    for c in gs:
        x, y = get(c, 'gcc', 'O2'), get(c, 'gcc', 'O3')
        cells.append(f'{(x["cycles_per_frame"] if s == "total" else x["stages"][s]["cycles_per_frame"]):.0f} / '
                     f'{(y["cycles_per_frame"] if s == "total" else y["stages"][s]["cycles_per_frame"]):.0f}')
    out.append(f'| {s} | ' + ' | '.join(cells) + ' |')
out.append('')

# ---- 4. headroom ----
out.append('### Table 4. Real-time headroom\n')
out.append(f'Formula: cycles per second of audio = cycles per frame x 16000 / 160 (100 frames per second). '
           f'Core fraction = that / (f_clk in Hz). **Assumed clock: {MHZ} MHz**, the value the SDK Mfcc example sets '
           f'(`FREQ_CL` in its CMakeLists.txt). It is an assumption, not a measurement: to rescale, multiply the '
           f'percentage by {MHZ} / (your MHz).\n')
out.append(f'| configuration | opt | compiler | cycles per s of audio | % of one core at {MHZ} MHz | x faster than real time |')
out.append('|---|---|---|---:|---:|---:|')
for c in configs:
    for o in ('O2', 'O3'):
        for cc in ('clang', 'gcc'):
            r = get(c, cc, o)
            if ran(r):
                out.append(f'| {c} | {o} | {cc} | {r["cycles_per_second_of_audio"]:.0f} | {100 * r["core_fraction_at_assumed_mhz"]:.2f}% | '
                           f'{1 / r["core_fraction_at_assumed_mhz"]:.0f} |')
out.append('')

def fsizes(r):
    f = {}
    for k, v in r['functions'].items():
        k = k.split('.')[0]
        if k in APP_FUNCS or k.startswith('rt_') or k.startswith('bench_') or k.startswith('__') or not k:
            continue
        f[k] = f.get(k, 0) + v
    return f



# ---- 5. size ----
out.append('### Table 5. Code size (bytes of .text)\n')
out.append('"pipeline code" is the sum of the MFCC kernel and glue functions that are linked in (the SDK kernels, the two '
           'fixed-point glue functions; not the harness, not libgcc). It is the like-for-like number. "app text" is the '
           'whole .text of the program linked with -ffunction-sections and --gc-sections; it also contains the harness, '
           'and for GCC 1634 bytes of libgcc 64-bit division used only by the harness print routine, so it flatters clang.\n')
out.append('| configuration | opt | clang pipeline code | GCC pipeline code | ratio | clang app text | GCC app text | ratio |')
out.append('|---|---|---:|---:|---:|---:|---:|---:|')
for c in configs:
    for o in ('O2', 'O3', 'Os'):
        a, b = get(c, 'clang', o), get(c if c != 'f16a+logf32+rt' else 'f16a+logf32', 'gcc', o)
        if not (ran(a) or ran(b)):
            continue
        ta = a['text_bytes'] if ran(a) else None
        tb = b['text_bytes'] if ran(b) else None
        pa = sum(fsizes(a).values()) if ran(a) else None
        pb = sum(fsizes(b).values()) if ran(b) else None
        out.append(f'| {c} | {o} | {pa or fail(a)} | {pb or "-"} | {ratio(pa, pb) if pa and pb else "-"} | '
                   f'{ta or "-"} | {tb or "-"} | {ratio(ta, tb) if ta and tb else "-"} |')
out.append('')

out.append('**Per function, -O2** (bytes; functions present after --gc-sections; inlined callees are counted in their caller, '
           'so a "-" means the function was inlined or not needed by that compiler):\n')
for c in ('fix16', 'f32', 'f16+logf32'):
    a, b = get(c, 'clang', 'O2'), get(c, 'gcc', 'O2')
    if not (ran(a) and ran(b)):
        continue
    fa, fb = fsizes(a), fsizes(b)
    out.append(f'*{c}*\n')
    out.append('| function | clang | GCC | ratio |')
    out.append('|---|---:|---:|---:|')
    for k in sorted(set(fa) | set(fb), key=lambda k: -(fa.get(k, 0) + fb.get(k, 0))):
        out.append(f'| `{k}` | {fa.get(k, "-")} | {fb.get(k, "-")} | {ratio(fa.get(k), fb.get(k), "{:.2f}")} |')
    out.append(f'| **pipeline code (sum)** | {sum(fa.values())} | {sum(fb.values())} | {ratio(sum(fa.values()), sum(fb.values()), "{:.2f}")} |')
    out.append('')

text = (R / 'report_text.md').read_text()
head, _, tail = text.partition('<!-- TABLES -->')
meta_lines = [f'- clang: `{meta["clang"]}` ({meta["clang_snapshot"]}), flags `{" ".join(meta["clang_flags"][:5])}`',
              f'- GCC: `{meta["gcc"]}`, flags `{" ".join(meta["gcc_flags"])}`']
(R / 'report.md').write_text((head + '\n'.join(out) + '\n' + tail).replace('<!-- META -->', '\n'.join(meta_lines)))
print('wrote report.md', len(out), 'table lines')
