/* B156: GVSoC driver for loops2.c. For every loop: result hash over several
 * lengths and pointer alignments, and cycles for n=256 with 4-byte-aligned
 * and with not-4-byte-aligned pointers. Prints
 *   R <name> <hash> <cycles aligned> <cycles misaligned>
 * Build/run: run_sim.sh */
#include "bench.h"
typedef int16_t s16; typedef uint16_t u16; typedef int8_t s8; typedef uint8_t u8;
#define NB 640
static u8 A[NB+16] __attribute__((aligned(4))), B[NB+16] __attribute__((aligned(4))), C[NB+16] __attribute__((aligned(4)));
/* clang turns copy16 into a memcpy call; there is no libc here */
void *memcpy(void *d, const void *s, unsigned n){ char *dd = d; const char *ss = s; for (volatile unsigned i = 0; i < n; i++) dd[i] = ss[i]; return d; }
static unsigned seed;
static unsigned rnd(void){ seed ^= seed << 13; seed ^= seed >> 17; seed ^= seed << 5; return seed; }
static void fill(void){ seed = 0x12345u; for (volatile int i = 0; i < NB+16; i++){ A[i]=rnd(); B[i]=rnd(); C[i]=rnd(); } }
static unsigned hashA(unsigned h){ for (volatile int i = 0; i < NB+16; i++){ h ^= A[i]; h *= 16777619u; } return h; }

#define P3(T) T*restrict, const T*restrict, const T*restrict, int
#define D3(n,T)  void n(T*restrict,const T*restrict,const T*restrict,int); static unsigned w_##n(void*a,void*b,void*c,int k){ n(a,b,c,k); return 0; }
#define D2(n,T)  void n(T*restrict,const T*restrict,int);                  static unsigned w_##n(void*a,void*b,void*c,int k){ n(a,b,k); return 0; }
#define D2S(n,T) void n(T*restrict,const T*restrict,int,int);              static unsigned w_##n(void*a,void*b,void*c,int k){ n(a,b,3,k); return 0; }
#define D2K(n,T) void n(T*restrict,const T*restrict,T,int);                static unsigned w_##n(void*a,void*b,void*c,int k){ n(a,b,(T)1234,k); return 0; }
#define R2(n,T)  int n(const T*restrict,const T*restrict,int);             static unsigned w_##n(void*a,void*b,void*c,int k){ return n(b,c,k); }
#define R1(n,T)  int n(const T*restrict,int);                              static unsigned w_##n(void*a,void*b,void*c,int k){ return n(b,k); }
#define R1S(n,T) s16 n(const T*restrict,int);                              static unsigned w_##n(void*a,void*b,void*c,int k){ return (unsigned)(int)n(b,k); }
#define K3(n,T)  void n(T*restrict,const T*restrict,const T*restrict);     static unsigned w_##n(void*a,void*b,void*c,int k){ n(a,b,c); return 0; }
D3(add16,s16) D3(add8,s8) D3(sub16,s16) D3(and16,s16) D3(min16,s16) D3(max8,s8) D3(maxu8,u8)
D2(abs16,s16) D2(shr16,s16) D2(shl8,u8) D2S(shrv16,s16) D2(addc16,s16) D2K(adds16,s16) D2(scale16,s16)
D2K(scaleq15,s16) D3(mul16,s16) D2(copy16,s16) D3(avg8,u8) D3(sat16,s16) D2(clip16,s16) D2(relu8,s8) D3(sel16,s16)
void set16(s16*,s16,int); static unsigned w_set16(void*a,void*b,void*c,int k){ set16(a,(s16)-77,k); return 0; }
R2(dot16,s16) R2(dot8,s8) R2(dotu8,u8) R1(sum16,s16) R1(sum8,s8) R1(max16r,s16) R1S(max16rn,s16) R2(sad8,u8)
#ifndef NO_SUM16N
R1S(sum16n,s16)
#endif
K3(add16_k64,s16) K3(add16_k63,s16) K3(add8_k4,s8) K3(add16_k2,s16)
int dot16_k64(const s16*restrict,const s16*restrict); static unsigned w_dot16_k64(void*a,void*b,void*c,int k){ return dot16_k64(b,c); }
void add16_nr(s16*,const s16*,const s16*,int); static unsigned w_add16_nr(void*a,void*b,void*c,int k){ add16_nr(a,b,c,k); return 0; }
void add8_nr(s8*,const s8*,const s8*,int);     static unsigned w_add8_nr(void*a,void*b,void*c,int k){ add8_nr(a,b,c,k); return 0; }
void inplace16(s16*,const s16*,int);           static unsigned w_inplace16(void*a,void*b,void*c,int k){ inplace16(a,b,k); return 0; }
/* overlapping call of the no-restrict loops: a = b + 1 element, must behave like the scalar loop */
static unsigned w_add16_ovl(void*a,void*b,void*c,int k){ add16_nr((s16*)a+1,(s16*)a,c,k); return 0; }
static unsigned w_add8_ovl(void*a,void*b,void*c,int k){ add8_nr((s8*)a+1,(s8*)a,c,k); return 0; }
K3(slp_add16,s16) K3(slp_add8,s8)
D3(add32,int)

struct ent { const char *name; unsigned (*f)(void*,void*,void*,int); int esz; };
#define E(n,sz) { #n, w_##n, sz }
static const struct ent tab[] = {
 E(add16,2),E(add8,1),E(sub16,2),E(and16,2),E(min16,2),E(max8,1),E(maxu8,1),E(abs16,2),E(shr16,2),E(shl8,1),E(shrv16,2),
 E(addc16,2),E(adds16,2),E(scale16,2),E(scaleq15,2),E(mul16,2),E(copy16,2),E(set16,2),E(avg8,1),E(sat16,2),E(clip16,2),
 E(relu8,1),E(sel16,2),E(dot16,2),E(dot8,1),E(dotu8,1),E(sum16,2),E(sum8,1),
#ifndef NO_SUM16N
 E(sum16n,2),
#endif
 E(max16r,2),E(max16rn,2),E(sad8,1),
 E(add16_k64,2),E(add16_k63,2),E(add8_k4,1),E(add16_k2,2),E(dot16_k64,2),E(add16_nr,2),E(add8_nr,1),E(inplace16,2),
 E(add16_ovl,2),E(add8_ovl,1),E(slp_add16,2),E(slp_add8,1),E(add32,4),
};
static const int lens[] = { 0, 1, 2, 3, 4, 5, 7, 8, 31, 64, 65 };
volatile int vzero = 0;
int main(void){
  for (unsigned t = 0; t < sizeof tab / sizeof tab[0]; t++) {
    const struct ent *e = &tab[t];
    unsigned h = 2166136261u;
    /* correctness: every length, and every combination of the 3 pointers being 4-aligned or off by one element */
    for (unsigned li = 0; li < sizeof lens / sizeof lens[0]; li++)
      for (int al = 0; al < 8; al++) {
        if (e->esz == 4 && al) continue;
        fill();
        unsigned r = e->f(A + ((al & 1) ? e->esz : 0), B + ((al & 2) ? e->esz : 0), C + ((al & 4) ? e->esz : 0), lens[li] + vzero);
        h ^= r; h *= 16777619u; h = hashA(h);
      }
    /* cycles: n = 256 (128 for 32-bit elements), all aligned, then all off by one element */
    uint32_t cyc[2];
    for (int m = 0; m < 2; m++) {
      if (e->esz == 4 && m) { cyc[m] = 0; continue; }
      fill();
      int off = m ? e->esz : 0;
      uint32_t t0 = bench_cycles32();
      e->f(A + off, B + off, C + off, (e->esz == 4 ? 128 : 256) + vzero);
      cyc[m] = bench_cycles32() - t0;
    }
    bench_puts("R "); bench_puts(e->name); bench_puts(" "); bench_print_hex(h);
    bench_puts(" "); bench_print_u32(cyc[0]); bench_puts(" "); bench_print_u32(cyc[1]); bench_puts("\n");
  }
  return 0;
}
