/* B156 investigation: loop shapes that need shuffles, masks or type changes. */
#include <stdint.h>
typedef int16_t s16; typedef int8_t s8; typedef uint8_t u8;
#define R restrict
void deint16(s16 *R o, const s16 *R in, int n){ for(int i=0;i<n;i++) o[i]=in[2*i]+in[2*i+1]; }       /* interleaved load, factor 2 */
void int16(s16 *R o, const s16 *R a, const s16 *R b, int n){ for(int i=0;i<n;i++){ o[2*i]=a[i]; o[2*i+1]=b[i]; } } /* interleaved store */
void rev16(s16 *R a, const s16 *R b, const s16 *R c, int n){ for(int i=0;i<n;i++) a[i]=b[n-1-i]+c[i]; } /* reverse load */
void rev8(s8 *R a, const s8 *R b, int n){ for(int i=0;i<n;i++) a[i]=b[n-1-i]; }
void cond16(s16 *R a, const s16 *R b, int n){ for(int i=0;i<n;i++) if(b[i]>0) a[i]=b[i]; }             /* conditional store */
void widen8to16(s16 *R a, const s8 *R b, int n){ for(int i=0;i<n;i++) a[i]=b[i]; }                     /* sext i8 -> i16 */
void narrow16to8(s8 *R a, const s16 *R b, int n){ for(int i=0;i<n;i++) a[i]=b[i]>>8; }                 /* trunc i16 -> i8 */
void mulhi16(s16 *R a, const s16 *R b, const s16 *R c, int n){ for(int i=0;i<n;i++) a[i]=(b[i]*c[i])>>15; } /* widening multiply */
void stride2(s16 *R a, const s16 *R b, int n){ for(int i=0;i<n;i++) a[i]=b[2*i]; }                     /* strided load */
void idx16(s16 *R a, const s16 *R b, const u8 *R idx, int n){ for(int i=0;i<n;i++) a[i]=b[idx[i]]; }   /* gather */
int find16(const s16 *R b, s16 k, int n){ for(int i=0;i<n;i++) if(b[i]==k) return i; return -1; }      /* early exit */
void iota8(u8 *a, int n){ for(int i=0;i<n;i++) a[i]=i; }                                               /* induction as data */
struct cpx { s16 re, im; };
void cadd(struct cpx *R o, const struct cpx *R a, const struct cpx *R b, int n){ for(int i=0;i<n;i++){ o[i].re=a[i].re+b[i].re; o[i].im=a[i].im+b[i].im; } }
