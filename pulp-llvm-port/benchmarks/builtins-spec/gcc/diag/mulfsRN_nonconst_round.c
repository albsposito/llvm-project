/* GCC diagnostic probe: mulfsRN_nonconst_round */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
int f(int a,int b,int r){return __builtin_pulp_mulfsRN(a,b,4,r);}
