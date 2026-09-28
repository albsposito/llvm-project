import subprocess, sys, re, json, os
S=sys.argv[1]
AS='/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-as'
OD='/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-objdump'
MC='/home/ubuntu/llvm-project/pulp-llvm-port/build/int-20/bin/llvm-mc'
LOD='/home/ubuntu/llvm-project/pulp-llvm-port/build/int-20/bin/llvm-objdump'
ATTRS=['+m,+c,+xpulpv', '+m,+c,+zfinx,+zhinx,+xpulpv', '+m,+c,+f,+d,+zfh,+xfalthalf,+xfvechalf,+xfvecalthalf,+xfauxhalf,+xfauxalthalf,+xpulpv']
res={}
for line in open(S+'/insns.txt').read().splitlines():
    enc=None; used=None
    for march in ('rv32imcxgap9','rv32imcxgap8'):
        open(S+'/t.s','w').write('\t'+line+'\n')
        p=subprocess.run([AS,'-march='+march]+(['-mPE=8','-mFC=1'] if 'gap9' in march else [])+[S+'/t.s','-o',S+'/t.o'],capture_output=True,text=True)
        if p.returncode==0:
            d=subprocess.run([OD,'-d',S+'/t.o'],capture_output=True,text=True).stdout
            m=re.search(r'^\s+0:\s+([0-9a-f]+)',d,re.M)
            enc=m.group(1); used=march; break
    llvm={}
    for a in ATTRS:
        p=subprocess.run([MC,'-triple=riscv32','-mattr='+a,'-show-encoding'],input=line+'\n',capture_output=True,text=True)
        if p.returncode==0:
            m=re.search(r'encoding: \[([^\]]*)\]',p.stdout)
            b=[int(x,16) for x in m.group(1).split(',')]
            llvm[a]=''.join('%02x'%x for x in reversed(b))
        else: llvm[a]='ERR: '+p.stderr.strip().splitlines()[0][:120] if p.stderr.strip() else 'ERR'
    # llvm disassembly of GCC encoding
    dis={}
    if enc:
        bs=bytes.fromhex(enc)[::-1]
        for a in ATTRS:
            p=subprocess.run([MC,'-triple=riscv32','-mattr='+a,'-disassemble'],input=' '.join('0x%02x'%x for x in bs)+'\n',capture_output=True,text=True)
            out=[l.strip() for l in p.stdout.splitlines() if l.strip() and not l.strip().startswith('.text')]
            dis[a]=(out[0] if out else ('invalid' if 'invalid' in p.stderr else p.stderr.strip()[:80]))
    res[line]={'gas_march':used,'gcc_enc':enc,'llvm_asm':llvm,'llvm_disasm_of_gcc_enc':dis}
    ok=[a for a in ATTRS if llvm[a]==enc]
    print('%-34s gcc=%s llvm-asm-match=%s | disasm=%s'%(line,enc,ok, dis.get(ATTRS[1]) if enc else '-'))
json.dump(res,open(S+'/enc.json','w'),indent=1)
