/* GCC diagnostic probe: sub2rotmj_unsigned */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
v2s f(v2u a,v2u b){return __builtin_pulp_sub2rotmj(a,b);}
