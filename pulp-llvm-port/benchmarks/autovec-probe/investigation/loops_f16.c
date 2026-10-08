/* B156 investigation: half-precision loops, in the shape of the SDK's
 * windowing / power-spectrum kernels (public gap_sdk, MfccBasicKernels:
 * WindowingReal2Real_f16, CmplxMagSquared_f16). */
#ifdef __clang__
typedef _Float16 f16;      /* our clang: float16 == _Float16 (task 20/F039) */
#else
typedef float16 f16;       /* GAP9 GCC built-in type name */
#endif
#define R restrict

void win_f16(f16 *R frame, const f16 *R win, int n){ for(int i=0;i<n;i++) frame[i]=frame[i]*win[i]; }
void win_f16_o(f16 *R out, const f16 *R in, const f16 *R win, int n){ for(int i=0;i<n;i++) out[i]=in[i]*win[i]; }
void add_f16(f16 *R a, const f16 *R b, const f16 *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]+c[i]; }
void axpy_f16(f16 *R y, const f16 *R x, f16 k, int n){ for(int i=0;i<n;i++) y[i]=y[i]+k*x[i]; }
void scale_f16(f16 *R a, const f16 *R b, f16 k, int n){ for(int i=0;i<n;i++) a[i]=b[i]*k; }
void max_f16(f16 *R a, const f16 *R b, const f16 *R c, int n){ for(int i=0;i<n;i++) a[i]=b[i]>c[i]?b[i]:c[i]; }
/* power spectrum: interleaved re/im in, one value out */
void magsq_f16(f16 *R out, const f16 *R in, int n){ for(int i=0;i<n;i++) out[i]=in[2*i]*in[2*i]+in[2*i+1]*in[2*i+1]; }
f16 dot_f16(const f16 *R b, const f16 *R c, int n){ f16 s=0; for(int i=0;i<n;i++) s+=b[i]*c[i]; return s; }
void win_f16_nr(f16 *frame, const f16 *win, int n){ for(int i=0;i<n;i++) frame[i]=frame[i]*win[i]; }
void win_f16_k256(f16 *R frame, const f16 *R win){ for(int i=0;i<256;i++) frame[i]=frame[i]*win[i]; }
