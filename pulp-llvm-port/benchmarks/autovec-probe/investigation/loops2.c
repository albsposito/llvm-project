/* B156 investigation: a wider set of plain C loops.
 * One function per loop so the assembly of each can be inspected alone.
 * Build lines are in run_gcc.sh / run_clang.sh. */
#include <stdint.h>
typedef int16_t s16; typedef uint16_t u16; typedef int8_t s8; typedef uint8_t u8;
#define R restrict

/* ---- element-wise, restrict, unknown trip count ---- */
void add16(s16 *R a, const s16 *R b, const s16 *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]+c[i]; }
void add8 (s8  *R a, const s8  *R b, const s8  *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]+c[i]; }
void sub16(s16 *R a, const s16 *R b, const s16 *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]-c[i]; }
void and16(s16 *R a, const s16 *R b, const s16 *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]&c[i]; }
void min16(s16 *R a, const s16 *R b, const s16 *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]<c[i]?b[i]:c[i]; }
void max8 (s8  *R a, const s8  *R b, const s8  *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]>c[i]?b[i]:c[i]; }
void maxu8(u8  *R a, const u8  *R b, const u8  *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]>c[i]?b[i]:c[i]; }
void abs16(s16 *R a, const s16 *R b, int n){ for(int i=0;i<n;i++) a[i]=b[i]<0?-b[i]:b[i]; }
void shr16(s16 *R a, const s16 *R b, int n){ for(int i=0;i<n;i++) a[i]=b[i]>>3; }
void shl8 (u8  *R a, const u8  *R b, int n){ for(int i=0;i<n;i++) a[i]=b[i]<<2; }
void shrv16(s16 *R a, const s16 *R b, int s, int n){ for(int i=0;i<n;i++) a[i]=b[i]>>s; }
void addc16(s16 *R a, const s16 *R b, int n){ for(int i=0;i<n;i++) a[i]=b[i]+5; }
void adds16(s16 *R a, const s16 *R b, s16 k, int n){ for(int i=0;i<n;i++) a[i]=b[i]+k; }
void scale16(s16 *R a, const s16 *R b, int n){ for(int i=0;i<n;i++) a[i]=b[i]*3; }
void scaleq15(s16 *R a, const s16 *R b, s16 k, int n){ for(int i=0;i<n;i++) a[i]=(b[i]*k)>>15; }
void mul16(s16 *R a, const s16 *R b, const s16 *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]*c[i]; }
void copy16(s16 *R a, const s16 *R b, int n){ for(int i=0;i<n;i++) a[i]=b[i]; }
void set16(s16 *a, s16 k, int n){ for(int i=0;i<n;i++) a[i]=k; }
void avg8(u8 *R a, const u8 *R b, const u8 *R c, int n){ for(int i=0;i<n;i++) a[i]=(b[i]+c[i]+1)>>1; }
/* saturating add (clip of a widened sum) and clip */
void sat16(s16 *R a, const s16 *R b, const s16 *R c, int n){
  for(int i=0;i<n;i++){ int t=b[i]+c[i]; if(t>32767)t=32767; if(t<-32768)t=-32768; a[i]=t; } }
void clip16(s16 *R a, const s16 *R b, int n){
  for(int i=0;i<n;i++){ int t=b[i]; if(t>255)t=255; if(t<-256)t=-256; a[i]=t; } }
void relu8(s8 *R a, const s8 *R b, int n){ for(int i=0;i<n;i++) a[i]=b[i]>0?b[i]:0; }
/* conditional store / select */
void sel16(s16 *R a, const s16 *R b, const s16 *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]>c[i]?b[i]-c[i]:0; }

/* ---- reductions ---- */
int dot16(const s16 *R b, const s16 *R c, int n){ int s=0; for(int i=0;i<n;i++) s+=b[i]*c[i]; return s; }
int dot8 (const s8  *R b, const s8  *R c, int n){ int s=0; for(int i=0;i<n;i++) s+=b[i]*c[i]; return s; }
int dotu8(const u8  *R b, const u8  *R c, int n){ int s=0; for(int i=0;i<n;i++) s+=b[i]*c[i]; return s; }
int sum16(const s16 *R b, int n){ int s=0; for(int i=0;i<n;i++) s+=b[i]; return s; }
int sum8 (const s8  *R b, int n){ int s=0; for(int i=0;i<n;i++) s+=b[i]; return s; }
#ifndef NO_SUM16N /* the experimental build crashes llc on this one (vecreduce_add), see report */
s16 sum16n(const s16 *R b, int n){ s16 s=0; for(int i=0;i<n;i++) s+=b[i]; return s; }
#endif
int max16r(const s16 *R b, int n){ int m=-32768; for(int i=0;i<n;i++) if(b[i]>m) m=b[i]; return m; }
s16 max16rn(const s16 *R b, int n){ s16 m=-32768; for(int i=0;i<n;i++) if(b[i]>m) m=b[i]; return m; }
int sad8(const u8 *R b, const u8 *R c, int n){ int s=0; for(int i=0;i<n;i++){ int d=b[i]-c[i]; s+= d<0?-d:d; } return s; }

/* ---- known trip counts ---- */
void add16_k64(s16 *R a, const s16 *R b, const s16 *R c){ for(int i=0;i<64;i++) a[i]=b[i]+c[i]; }
void add16_k63(s16 *R a, const s16 *R b, const s16 *R c){ for(int i=0;i<63;i++) a[i]=b[i]+c[i]; }
void add8_k4 (s8  *R a, const s8  *R b, const s8  *R c){ for(int i=0;i<4;i++) a[i]=b[i]+c[i]; }
void add16_k2(s16 *R a, const s16 *R b, const s16 *R c){ for(int i=0;i<2;i++) a[i]=b[i]+c[i]; }
int dot16_k64(const s16 *R b, const s16 *R c){ int s=0; for(int i=0;i<64;i++) s+=b[i]*c[i]; return s; }
/* known trip count AND known alignment (global arrays) */
s16 GA[64], GB[64], GC[64];
void add16_glob(void){ for(int i=0;i<64;i++) GA[i]=GB[i]+GC[i]; }

/* ---- no restrict (needs a run-time overlap check) ---- */
void add16_nr(s16 *a, const s16 *b, const s16 *c, int n){ for(int i=0;i<n;i++) a[i]=b[i]+c[i]; }
void add8_nr (s8  *a, const s8  *b, const s8  *c, int n){ for(int i=0;i<n;i++) a[i]=b[i]+c[i]; }
void inplace16(s16 *a, const s16 *b, int n){ for(int i=0;i<n;i++) a[i]+=b[i]; }

/* ---- straight-line code (SLP) ---- */
void slp_add16(s16 *R a, const s16 *R b, const s16 *R c){ a[0]=b[0]+c[0]; a[1]=b[1]+c[1]; }
void slp_add8 (s8  *R a, const s8  *R b, const s8  *R c){ a[0]=b[0]+c[0]; a[1]=b[1]+c[1]; a[2]=b[2]+c[2]; a[3]=b[3]+c[3]; }
struct px { u8 r,g,b,a; };
void slp_px(struct px *R d, const struct px *R s, const struct px *R t){
  d->r=s->r+t->r; d->g=s->g+t->g; d->b=s->b+t->b; d->a=s->a+t->a; }

/* ---- 32-bit elements: must stay scalar on both compilers (no 2x32 vectors) ---- */
void add32(int *R a, const int *R b, const int *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]+c[i]; }
