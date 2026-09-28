/* GCC diagnostic probe: macfsN_nonconst */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
int f(int a,int b,int c,int n){return __builtin_pulp_macfsN(a,b,c,n);}
