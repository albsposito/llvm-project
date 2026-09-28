#include "bench.h"
typedef int (*F)(int,int); typedef int (*G)(int,const void*);
#define NK 24
#define D(n) extern int k##n(int,int); extern int r##n(int,int);
D(0)D(1)D(2)D(3)D(4)D(5)D(6)D(7)D(8)D(9)D(10)D(11)D(12)D(13)D(14)D(15)D(16)D(17)D(18)D(19)D(20)D(21)D(22)D(23)
F K[]={k0,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,k17,k18,k19,k20,k21,k22,k23};
F R[]={r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23};
extern int kl0(int,const void*),kl1(int,const void*),kl2(int,const void*),kl3(int,const void*);
extern int rl0(int,const void*),rl1(int,const void*),rl2(int,const void*),rl3(int,const void*);
G KL[]={kl0,kl1,kl2,kl3}; G RL[]={rl0,rl1,rl2,rl3};
int V[]={-2147483647-1,-2147483647,-100000,-65536,-65535,-32768,-32767,-256,-255,-129,-128,-127,-100,-6,-5,-4,-2,-1,0,1,2,4,5,6,100,127,128,255,256,32767,32768,65535,65536,100000,2147483646,2147483647};
#define NV 36
static int bad=0,n=0;
static void chk(int f,int x,int b,int g,int e){ n++; if(g!=e){ if(bad<30){bench_puts("MISMATCH f="); bench_print_i32(f); bench_puts(" x="); bench_print_i32(x); bench_puts(" b="); bench_print_i32(b); bench_puts(" got "); bench_print_i32(g); bench_puts(" exp "); bench_print_i32(e); bench_putchar('\n');} bad++; } }
int main(void){ unsigned s=777;
 for(int f=0;f<NK;f++){
  for(int i=0;i<NV;i++) for(int j=0;j<NV;j++) chk(f,V[i],V[j],K[f](V[i],V[j]),R[f](V[i],V[j]));
  for(int i=0;i<1500;i++){ s=s*1103515245u+12345u; int x=(int)s>>(s&15); s=s*1103515245u+12345u; int b=(int)s>>(s&31); chk(f,x,b,K[f](x,b),R[f](x,b)); }
 }
 for(int f=0;f<4;f++) for(int i=0;i<NV;i++) for(int c=0;c<256;c++){ unsigned char u=(unsigned char)c; chk(100+f,V[i],c,KL[f](V[i],&u),RL[f](V[i],&u)); }
 bench_puts("checks="); bench_print_i32(n); bench_puts(" mismatches="); bench_print_i32(bad); bench_putchar('\n'); return bad>0; }
