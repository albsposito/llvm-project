#include "bench.h"
static volatile int32_t vn[] = {1, 2, 3, 7, 64, 1000};
static int32_t data[1000]; static int16_t a16[1000], b16[1000]; static uint16_t dst[1000];
__attribute__((noinline)) static int32_t work(int n){int acc=0;for(int i=0;i<n;i++)acc+=i^(acc>>3);return acc;}
__attribute__((noinline)) static uint32_t sum_loop(const uint32_t *a,uint32_t n){uint32_t s=0;for(uint32_t i=0;i<n;i++)s+=a[i];return s;}
__attribute__((noinline)) static int32_t dot16(const int16_t *a,const int16_t *b,int n){int32_t s=0;for(int i=0;i<n;i++)s+=a[i]*b[i];return s;}
__attribute__((noinline)) static void copy16(uint16_t *d,const int16_t *s,int n){for(int i=0;i<n;i++)d[i]=s[i];}
__attribute__((noinline)) static int32_t countdown(const int32_t *p,int n){int32_t acc=0;do{acc+=*p++ ^ n;}while(--n);return acc;}
int main(void){
  for(int i=0;i<1000;i++){data[i]=i*7+1;a16[i]=(int16_t)(i*3-500);b16[i]=(int16_t)(7-i);}
  uint32_t h=0;
  for(unsigned k=0;k<sizeof(vn)/sizeof(vn[0]);k++){int n=vn[k];
    int32_t r1=work(n); uint32_t r2=sum_loop((const uint32_t*)data,n); int32_t r3=dot16(a16,b16,n);
    copy16(dst,a16,n); uint32_t r4=0; for(int i=0;i<n;i++) r4=r4*31+dst[i];
    int32_t r5=countdown(data,n);
    bench_puts("n="); bench_print_i32(n); bench_puts(" work="); bench_print_i32(r1); bench_puts(" sum="); bench_print_u32(r2);
    bench_puts(" dot="); bench_print_i32(r3); bench_puts(" copy="); bench_print_u32(r4); bench_puts(" cd="); bench_print_i32(r5); bench_putchar('\n');
    h=h*33+r1+r2+r3+r4+r5;}
  bench_puts("hash="); bench_print_u32(h); bench_putchar('\n'); return 0;}
