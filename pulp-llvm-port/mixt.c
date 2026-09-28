#include "bench.h"
typedef long long v2l __attribute__((vector_size(16)));
static unsigned H;
static void mix(const void *p, int n){const unsigned char*c=p;for(int i=0;i<n;i++)H=(H^c[i])*16777619u;}
volatile unsigned SEED=12345;
static unsigned rnd(void){unsigned x=SEED;x^=x<<13;x^=x>>17;x^=x<<5;SEED=x;return x;}
#define VEC(t) ({ t _v; for (unsigned _i=0;_i<sizeof(t);_i++) ((unsigned char*)&_v)[_i]=(unsigned char)rnd(); _v; })
__attribute__((noinline)) v2l id(v2l a){ return a; }
int main(void){ H=2166136261u; for(int it=0;it<8;it++){ v2l a=VEC(v2l), r; r=id(a); mix(&r,sizeof r);} bench_print_hex(H); bench_putchar(10); return 0; }
