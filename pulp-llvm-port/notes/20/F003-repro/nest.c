#include "bench.h"
static volatile int32_t vn[] = {1, 2, 5, 17, 100}; static volatile int32_t vm[] = {1, 3, 8, 16};
static int16_t in[256], co[32]; static int32_t out[128];
__attribute__((noinline)) static void fir(const int16_t *x,const int16_t *c,int32_t *o,int n,int m){
  for(int i=0;i<n;i++){int32_t acc=0; for(int j=0;j<m;j++) acc+=x[i+j]*c[j]; o[i]=acc;}}
__attribute__((noinline)) static uint32_t single31(uint32_t x,uint32_t y){uint32_t cnt=0;for(int i=0;i<31;i++){x=x*3+(y>>5);y^=x;cnt++;}return (x^y)+cnt;}
int main(void){
  for(int i=0;i<256;i++) in[i]=(int16_t)(i*37-4000); for(int j=0;j<32;j++) co[j]=(int16_t)(j*5-70);
  uint32_t h=0;
  for(unsigned a=0;a<5;a++) for(unsigned b=0;b<4;b++){int n=vn[a],m=vm[b];
    for(int i=0;i<128;i++) out[i]=0x55;
    fir(in,co,out,n,m); uint32_t r=0; for(int i=0;i<128;i++) r=r*31+(uint32_t)out[i];
    bench_puts("n="); bench_print_i32(n); bench_puts(" m="); bench_print_i32(m); bench_puts(" fir="); bench_print_u32(r); bench_putchar('\n'); h=h*33+r;}
  uint32_t s=single31(vn[1],vm[2]); bench_puts("single31="); bench_print_u32(s); bench_putchar('\n');
  bench_puts("hash="); bench_print_u32(h+s); bench_putchar('\n'); return 0;}
