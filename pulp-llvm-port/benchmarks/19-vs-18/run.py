#!/usr/bin/env python3
import collections,hashlib,json,pathlib,re,statistics,subprocess,time,os
D=pathlib.Path(__file__).resolve().parent; H=D.parent.parent
bins={'18':H/'toolchains/ref-18/bin','19':H/'build/int-19/bin'}
flags=['--target=riscv32-unknown-elf','-march=rv32imc_xpulpv2','-mabi=ilp32','-ffreestanding','-fno-builtin']
commands=[]
def run(cmd):
 commands.append([str(x) for x in cmd]); return subprocess.run(cmd,text=True,capture_output=True)
lines=(D/'kernels.c').read_text().splitlines(); sources=D/'sources'; sources.mkdir(exist_ok=True)
for line in lines[4:]:
 name=re.search(r'(\w+)\(',line)[1]; (sources/(name+'.c')).write_text('\n'.join(lines[:4]+[line])+'\n')
rows=[]
for opt in ['O2','O3']:
 for src in sorted(sources.glob('*.c')):
  for version,B in bins.items():
   out=D/f'{version}-{opt}'; out.mkdir(exist_ok=True); obj=out/(src.stem+'.o')
   cmd=[str(B/'clang'),*flags,'-'+opt,'-c',str(src),'-o',str(obj)]
   p=run(cmd); (out/(src.stem+'.stderr')).write_text(p.stderr)
   row=dict(version=version,opt=opt,kernel=src.stem,returncode=p.returncode,times=[]); rows.append(row)
   if p.returncode: continue
   p=run([str(bins['19']/'llvm-objdump'),'-d','--mattr=+xpulpv,+c',str(obj)]); dis=p.stdout; (out/(src.stem+'.dis')).write_text(dis)
   p=run([str(bins['18']/'llvm-nm'),'-S','--defined-only',str(obj)]); nm=p.stdout; (out/(src.stem+'.symbols')).write_text(nm)
   row['size']=next(int(l.split()[1],16) for l in nm.splitlines() if len(l.split())==4 and l.split()[3]==src.stem)
   mnems=collections.Counter()
   for l in dis.splitlines():
    m=re.match(r'^\s*[0-9a-f]+:\s+(?:[0-9a-f]{2,8}\s+)+([a-z][\w.]*)',l)
    if m: mnems[m[1]]+=1
   row['instructions']=mnems; row['object_sha256']=hashlib.sha256(obj.read_bytes()).hexdigest()
 # Timing entire successful common corpus, 7 paired samples alternating order.
 good=[s for s in sorted(sources.glob('*.c')) if all(r['returncode']==0 for r in rows if r['opt']==opt and r['kernel']==s.stem)]
 for sample in range(7):
  for version in (['18','19'] if sample%2==0 else ['19','18']):
   for src in good:
    t=time.perf_counter(); p=run([str(bins[version]/'clang'),*flags,'-'+opt,'-c',str(src),'-o',str(D/f'{version}-{opt}'/'timing.o')]); elapsed=time.perf_counter()-t
    assert p.returncode==0
    next(r for r in rows if r['version']==version and r['opt']==opt and r['kernel']==src.stem)['times'].append(elapsed)
metadata={v:run([str(b/'clang'),'--version']).stdout for v,b in bins.items()}
(D/'results.json').write_text(json.dumps(dict(flags=flags,versions=metadata,load_average=os.getloadavg(),source_sha256=hashlib.sha256((D/'kernels.c').read_bytes()).hexdigest(),rows=rows),indent=2))
(D/'commands.json').write_text(json.dumps(commands,indent=2))
print('Completed',len(rows),'compilations')
