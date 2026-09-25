from pathlib import Path
import re, subprocess, tempfile
root=Path(__file__).resolve().parents[2]
p=root/'wt/19-T001/llvm/test/CodeGen/RISCV/freploop-nested.ll'
original=p.read_text()
with tempfile.TemporaryDirectory(prefix='T001-') as td:
 t=Path(td)/p.name; t.write_text(original)
 subprocess.run(['python3',str(root/'wt/19-T001/llvm/utils/update_llc_test_checks.py'),'--llc-binary',str(root/'build/int-19/bin/llc'),str(t)],check=True)
 generated=t.read_text()
 aliases=re.findall(r'^; CHECK-NEXT:\s+(csr[sc]i 1984, 1)$',generated,re.M)
 assert aliases==['csrsi 1984, 1','csrci 1984, 1','csrsi 1984, 1','csrci 1984, 1','csrsi 1984, 1','csrci 1984, 1']
 matches=list(re.finditer(r'(?m)^(; CHECK(?:-NEXT)?:\s+)csrr([sc])i  \{\{\.\*\}\}, 1984, 1$',original))
 assert len(matches)==5
 i=iter(aliases[:5])
 def replace(m):
  out=next(i); assert out.startswith('csr'+m[2]+'i ')
  return m[1]+out
 result=re.sub(r'(?m)^(; CHECK(?:-NEXT)?:\s+)csrr([sc])i  \{\{\.\*\}\}, 1984, 1$',replace,original)
 p.write_text(result)
