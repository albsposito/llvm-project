import subprocess, os, json
OUT='/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/builtins-spec/gcc/diag'
os.makedirs(OUT,exist_ok=True)
GCC='/home/ubuntu/gap_riscv_toolchain_ubuntu/bin/riscv32-unknown-elf-gcc'
H='typedef short v2s __attribute__((vector_size(4)));\ntypedef signed char v4s __attribute__((vector_size(4)));\ntypedef float16 v2h __attribute__((vector_size(4)));\ntypedef float16alt v2ah __attribute__((vector_size(4)));\n'
cases=[
 ('f32max_int','float f(int a,int b){return __builtin_pulp_f32max(a,b);}'),
 ('f32max_double','float f(double a,double b){return __builtin_pulp_f32max(a,b);}'),
 ('f32max_ptr','float f(float *a,float b){return __builtin_pulp_f32max(a,b);}'),
 ('f32max_v2s','float f(v2s a,float b){return __builtin_pulp_f32max(a,b);}'),
 ('f32max_fold','float f(void){return __builtin_pulp_f32max(__builtin_nanf(""), 1.0f);}'),
 ('f32min_nan','float f(float a){return __builtin_pulp_f32min(a, __builtin_nanf(""));}'),
 ('f32sqrt_int','float f(int a){return __builtin_pulp_f32sqrt(a);}'),
 ('f32sqrt_static_init','static float k = __builtin_pulp_f32max(1.0f, 2.0f); float f(void){return k;}'),
 ('rintsf2_int','int f(int a){return __builtin_pulp_rintsf2(a);}'),
 ('rintsf2_double','int f(double a){return __builtin_pulp_rintsf2(a);}'),
 ('add2div2_int','v2s f(int a,int b){return __builtin_pulp_add2div2(a,b);}'),
 ('add2div2_v4s','v2s f(v4s a,v4s b){return __builtin_pulp_add2div2(a,b);}'),
 ('add2div2_const','v2s f(void){return __builtin_pulp_add2div2((v2s){0x7fff,-4},(v2s){1,-4});}'),
 ('cplxmuls2_int','v2s f(int a,int b){return __builtin_pulp_cplxmuls2(a,b);}'),
 ('cplxmuls2_const','v2s f(void){return __builtin_pulp_cplxmuls2((v2s){16384,0},(v2s){16384,16384});}'),
 ('cplx_conj_v4s','v2s f(v4s a){return __builtin_pulp_cplx_conj(a);}'),
 ('sub2rotmj_unsigned','typedef unsigned short v2u __attribute__((vector_size(4)));\nv2s f(v2u a,v2u b){return __builtin_pulp_sub2rotmj(a,b);}'),
 ('mulfsN_nonconst','int f(int a,int b,int n){return __builtin_pulp_mulfsN(a,b,n);}'),
 ('mulfsN_32','int f(int a,int b){return __builtin_pulp_mulfsN(a,b,32);}'),
 ('mulfsN_neg','int f(int a,int b){return __builtin_pulp_mulfsN(a,b,-1);}'),
 ('mulfsN_0','int f(int a,int b){return __builtin_pulp_mulfsN(a,b,0);}'),
 ('mulsN_nonconst_existing','int f(int a,int b,int n){return __builtin_pulp_mulsN(a,b,n);}'),
 ('mulfsRN_badround','int f(int a,int b){return __builtin_pulp_mulfsRN(a,b,4,3);}'),
 ('mulfsRN_nonconst_round','int f(int a,int b,int r){return __builtin_pulp_mulfsRN(a,b,4,r);}'),
 ('mulfsRN_nonconst_both','int f(int a,int b,int n){return __builtin_pulp_mulfsRN(a,b,n,1<<(n-1));}'),
 ('macfsN_nonconst','int f(int a,int b,int c,int n){return __builtin_pulp_macfsN(a,b,c,n);}'),
 ('macfuRN_nonconst','int f(int a,int b,int c,int n){return __builtin_pulp_macfuRN(a,b,c,n,1<<(n-1));}'),
 ('macfs_asm','int f(int a,int b,int c){return __builtin_pulp_macfs(a,b,c);}'),
 ('mul64hu_ptr','int f(int *a,int b){return __builtin_pulp_mul64hu(a,b);}'),
 ('mul64hu_ll','int f(long long a,long long b){return __builtin_pulp_mul64hu(a,b);}'),
 ('trunch_ll','short f(long long a){return __builtin_pulp_trunch(a);}'),
 ('trunch_ptr','short f(short *a){return __builtin_pulp_trunch(a);}'),
 ('truncb_sign','int f(int a){return __builtin_pulp_truncb(a);}'),
 ('f16max_float','float16 f(float a,float b){return __builtin_pulp_f16max(a,b);}'),
 ('f16altmax_f16','float16alt f(float16 a,float16 b){return __builtin_pulp_f16altmax(a,b);}'),
 ('f16max2_v2ah','v2h f(v2ah a,v2ah b){return __builtin_pulp_f16max2(a,b);}'),
 ('v2hftov2ohf_v2s','v2ah f(v2s a){return __builtin_pulp_v2hftov2ohf(a);}'),
 ('v2hitov2hf_v2h','v2h f(v2h a){return __builtin_pulp_v2hitov2hf(a);}'),
 ('CoreCount_m1_arg','int f(void){return __builtin_pulp_CoreCount_m1(1);}'),
]
res={}
for name,body in cases:
    src='/* GCC diagnostic probe: %s */\n'%name+H+body+'\n'
    open(f'{OUT}/{name}.c','w').write(src)
    p=subprocess.run([GCC,'-march=rv32imcxgap9','-mPE=8','-mFC=1','-O2','-Wall','-S',f'{name}.c','-o',f'{name}.s'],cwd=OUT,capture_output=True,text=True)
    asm=''
    if p.returncode==0:
        asm='; '.join(l.strip().replace('\t',' ') for l in open(f'{OUT}/{name}.s') if l.startswith('\t') and not l.startswith('\t.'))
    else:
        if os.path.exists(f'{OUT}/{name}.s'): os.remove(f'{OUT}/{name}.s')
    diag=[l for l in p.stderr.splitlines() if ('error' in l or 'warning' in l or 'note' in l)]
    res[name]={'rc':p.returncode,'diag':[d.split(': ',1)[1] if ': ' in d else d for d in diag],'asm':asm}
    print('%-26s rc=%d %s | %s'%(name,p.returncode,' || '.join(res[name]['diag'])[:260],asm[:160]))
json.dump(res,open(OUT+'/diag.json','w'),indent=1)
