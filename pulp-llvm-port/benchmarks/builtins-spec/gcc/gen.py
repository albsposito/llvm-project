import json, re, subprocess, os, sys
S=sys.argv[1]; OUT='/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/builtins-spec/gcc'
GCC='/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc'
g9=json.load(open(S+'/probe_gap9.json')); g8=json.load(open(S+'/probe_gap8.json'))
HDR='''/* GCC reference test for %s. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=%s %s-O2 -S %s.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
%s
'''
FP16='typedef float16 v2h __attribute__((vector_size(4)));\ntypedef float16alt v2ah __attribute__((vector_size(4)));\n'
def ctype(t):
    return {'__vector(2) short int':'v2s','__vector(4) signed char':'v4s','__vector(2) float16':'v2h',
            '__vector(2) float16alt':'v2ah'}.get(t,t)
meta={}
for n in open(S+'/todo.txt').read().split():
    info=g9.get(n); march='rv32imcxgap9'; extra='-mPE=8 -mFC=1 '
    if not info['known']:
        info=g8.get(n); march='rv32imcxgap8'; extra=''
        if not info or not info['known']:
            meta[n]={'gcc':'unknown'}; continue
    short=n.replace('__builtin_pulp_','')
    args=[ctype(a) for a in info['args']]; ret=ctype(info['ret'])
    fp16=any('v2h' in a or 'v2ah' in a or 'float16' in a for a in args+[ret])
    body=[]
    params=', '.join('%s a%d'%(a,i) for i,a in enumerate(args)) or 'void'
    # immediate params: N / R positions
    imm=[]
    if re.search(r'(N|RN)$',short):
        # layout per GapBuiltins wrappers: mulfsN(x,y,n) mulfsRN(x,y,n,r) macfsN(x,y,acc,n) macfsRN(x,y,acc,n,r)
        nidx = 3 if short.startswith('mac') else 2
        imm=[nidx] + ([nidx+1] if short.endswith('RN') else [])
    if imm:
        regargs=[i for i in range(len(args)) if i not in imm]
        rp=', '.join('%s a%d'%(args[i],i) for i in regargs)
        for N in (1,5,11,15,16,31):
            cargs=[]
            for i in range(len(args)):
                if i==imm[0]: cargs.append(str(N))
                elif len(imm)>1 and i==imm[1]: cargs.append(str(1<<(N-1)))
                else: cargs.append('a%d'%i)
            body.append('%s t_%s_n%d(%s) { return %s(%s); }'%(ret,short,N,rp,n,', '.join(cargs)))
        body.append('/* non-constant N (see %s_bad.c for diagnostics) */'%short)
    else:
        body.append('%s t_%s(%s) { return %s(%s); }'%(ret,short,params,n,', '.join('a%d'%i for i in range(len(args)))))
        if short in ('f32max','f32min','f32abs','f32sqrt','rintsf2','rdownsf2','rupsf2','trunch','truncb','mul64hs','mul64hu','mul64hus','cplx_conj'):
            # constant-folding probe
            if args and args[0]=='float':
                cv=', '.join(['2.5f','-3.5f'][:len(args)])
            elif args and args[0]=='int':
                cv=', '.join(['0x12345678','-7'][:len(args)])
            else:
                cv=', '.join(['(v2s){1,-2}','(v2s){3,4}'][:len(args)])
            body.append('%s t_%s_const(void) { return %s(%s); }'%(ret,short,n,cv))
        if short=='rintsf2':
            body.append('int t_rintsf2_scale(float x, float s) { return (int) __builtin_pulp_rintsf2(x*s); }')
        if short=='trunch':
            body.append('void t_trunch_store(short *p, int a, int b) { p[0] = __builtin_pulp_trunch(a + b); p[4] = __builtin_pulp_trunch(a - b); }')
    src=HDR%(n,march,extra,short,FP16 if fp16 else '')+'\n'.join(body)+'\n'
    open(f'{OUT}/{short}.c','w').write(src)
    cmd=[GCC,'-march='+march]+extra.split()+['-O2','-S',f'{short}.c','-o',f'{short}.s']
    p=subprocess.run(cmd,cwd=OUT,capture_output=True,text=True)
    meta[n]={'gcc':'ok' if p.returncode==0 else 'fail','march':march,'args':args,'ret':ret,'imm':imm,'fp16':fp16,'stderr':p.stderr.strip()}
    print(n, meta[n]['gcc'], p.stderr.strip()[:300])
json.dump(meta,open(S+'/gen_meta.json','w'),indent=1)
