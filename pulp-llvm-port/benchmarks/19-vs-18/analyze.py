#!/usr/bin/env python3
import pathlib,json,subprocess,statistics
D=pathlib.Path(__file__).resolve().parent; H=D.parent.parent
j=json.loads((D/'results.json').read_text()); pairs=[]
for opt in ['O2','O3']:
 for n in sorted(set(r['kernel'] for r in j['rows'])):
  a,b=[next(r for r in j['rows'] if r['kernel']==n and r['version']==v and r['opt']==opt) for v in ['18','19']]
  if a['returncode'] or b['returncode']: continue
  data=[]
  for v in ['18','19']:
   p=D/f'{v}-{opt}'/f'{n}.text'; subprocess.run([str(H/'toolchains/ref-18/bin/llvm-objcopy'),'--dump-section',f'.text={p}',str(D/f'{v}-{opt}'/f'{n}.o')],check=True); data.append(p.read_bytes())
  pairs.append({'opt':opt,'kernel':n,'text_identical':data[0]==data[1]})
(D/'text-equivalence.json').write_text(json.dumps(pairs,indent=2))
assert len(pairs)==20 and all(r['text_identical'] for r in pairs)
for o in ['O2','O3']:
 for v in ['18','19']:
  rr=[r for r in j['rows'] if r['version']==v and r['opt']==o and r['times']]
  print(o,v,'bytes',sum(r['size'] for r in rr),'instructions',sum(sum(r['instructions'].values()) for r in rr),'sum_of_per_kernel_median_seconds',sum(statistics.median(r['times']) for r in rr))
