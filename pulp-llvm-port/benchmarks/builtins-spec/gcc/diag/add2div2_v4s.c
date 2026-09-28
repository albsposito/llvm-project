/* GCC diagnostic probe: add2div2_v4s */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
v2s f(v4s a,v4s b){return __builtin_pulp_add2div2(a,b);}
