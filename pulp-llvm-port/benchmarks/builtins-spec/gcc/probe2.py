import subprocess, re, json, sys
S=sys.argv[1]; march=sys.argv[2]; out=sys.argv[3]
GCC='/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc'
FL=['-march='+march,'-O2','-S','-o','/dev/null'] + (['-mPE=8','-mFC=1'] if 'gap9' in march else [])
names=open(S+'/todo.txt').read().split()
def run(src):
    p=subprocess.run([GCC]+FL+['-x','c','-'],input=src,capture_output=True,text=True)
    return p.stderr
def parse(e,n):
    args={}; cur=None
    for l in e.splitlines():
        m=re.search(r"argument (\d+) of '%s'"%re.escape(n),l)
        if m: cur=int(m.group(1)); continue
        m=re.search(r"note: expected '([^']*)'",l)
        if m and cur: args[cur]=m.group(1); cur=None
    return args
res={}
for n in names:
    e0=run('void f(void){ (void)%s(); }\n'%n)
    if 'implicit declaration' in e0:
        res[n]={'known':False}; print(n,'UNKNOWN'); continue
    arity=None
    for k in range(0,7):
        e=run('struct S{int a;} s;\nvoid f(void){ (void)%s(%s); }\n'%(n,', '.join(['s']*k)))
        if 'too many arguments' in e or 'too few arguments' in e: continue
        arity=k; a=parse(e,n); break
    args=[a.get(i+1) for i in range(arity)]
    # return type: call with valid-typed args (use typedef'd locals) and assign to struct
    decls=[]; 
    for i,t in enumerate(args):
        tt=t
        vm=re.match(r'__vector\((\d+)\) (.*)',t or '')
        if vm: decls.append('typedef %s T%d __attribute__((vector_size(%d*sizeof(%s)))); T%d a%d;'%(vm.group(2),i,int(vm.group(1)),vm.group(2),i,i))
        else: decls.append('%s a%d;'%(t,i))
    e=run('struct S{int a;} s;\n%s\nvoid f(void){ s = %s(%s); }\n'%('\n'.join(decls),n,', '.join('a%d'%i for i in range(arity))))
    m=re.search(r"from type '([^']*)'",e)
    ret=m.group(1) if m else ('void' if 'void value' in e else None)
    other=[l for l in e.splitlines() if 'error' in l and 'incompatible types when assigning' not in l]
    res[n]={'known':True,'arity':arity,'args':args,'ret':ret,'errors_with_valid_nonconst_args':other}
    print(n,arity,args,'->',ret, other[:2],flush=True)
json.dump(res,open(out,'w'),indent=1)
