/* GCC diagnostic probe: mul64hu_ll */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
int f(long long a,long long b){return __builtin_pulp_mul64hu(a,b);}
