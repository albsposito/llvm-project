#!/usr/bin/env python3
import pathlib,subprocess,json,re,collections,hashlib
D=pathlib.Path(__file__).resolve().parent; H=D.parent.parent
src=D/'xpulp-hwloop.ll'
src.write_bytes(subprocess.check_output(['git','show','port/18:llvm/test/CodeGen/RISCV/xpulp-hwloop.ll'],cwd=H))
commands=[]; rows=[]
for v,b in [('18',H/'toolchains/ref-18/bin'),('19',H/'build/int-19/bin')]:
 obj=D/f'hwloop{v}.o'; cmd=[str(b/'llc'),'-O=2','-march=riscv32','-mattr=+xpulpv','-filetype=obj',str(src),'-o',str(obj)]; commands.append(cmd)
 p=subprocess.run(cmd,capture_output=True,text=True); (D/f'hwloop{v}.stderr').write_text(p.stderr); assert p.returncode==0
 cmd=[str(H/'build/int-19/bin/llvm-objdump'),'-d','--mattr=+xpulpv,+c',str(obj)]; commands.append(cmd)
 dis=subprocess.check_output(cmd,text=True); (D/f'hwloop{v}.dis').write_text(dis)
 cmd=[str(H/'toolchains/ref-18/bin/llvm-nm'),'-S','--defined-only',str(obj)]; commands.append(cmd)
 nm=subprocess.check_output(cmd,text=True); (D/f'hwloop{v}.symbols').write_text(nm)
 sizes={l.split()[3]:int(l.split()[1],16) for l in nm.splitlines() if len(l.split())==4 and l.split()[2]=='T'}
 rows.append({'version':v,'sizes':sizes})
cmd=['python3',str(H/'scripts/mix_diff.py'),str(D/'hwloop18.dis'),str(D/'hwloop19.dis'),'--out',str(D/'hwloop-mix.json')]; commands.append(cmd)
mix_result=subprocess.run(cmd,capture_output=True)
(D/'supplement.json').write_text(json.dumps({'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'commands':commands,'rows':rows},indent=2))
