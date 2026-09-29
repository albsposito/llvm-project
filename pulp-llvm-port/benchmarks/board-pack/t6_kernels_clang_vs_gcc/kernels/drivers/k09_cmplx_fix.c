/* k09 CmplxMagSquared_Fix16: MagSquared[i] = re^2 + im^2 over 512 complex int16. */
#include "rt.h"
#ifdef RT_HOST
#include <stdlib.h>
#endif
typedef struct { void *__restrict__ FrameIn; void *__restrict__ FrameOut; int N; int NFrames;
                 short int ExtraQ; short int Input_QFormat; signed char *__restrict__ shift_fft; } CmplxMag_T;
extern void CmplxMagSquared_Fix16(CmplxMag_T *Arg);
/* The whole SDK file (CmplxFunctionsFix.c) also holds CmplxMag_Fix32*, which reference the
 * FastMath usqrt_17_15. It is never called by CmplxMagSquared_Fix16; this stub only satisfies
 * the linker and aborts the run (exit 99) if it were ever reached. */
unsigned int usqrt_17_15(unsigned int x)
{
#ifdef RT_HOST
    (void)x; exit(99);
#else
    (void)x; bench_exit(99);
#endif
}
#define N 512
static int16_t In[2 * N];
static uint32_t Out[N];
int main(void)
{
    rt_seed(0x1009u); rt_fill_i16(In, rt_n(2 * N), -16384, 16383);  /* re^2+im^2 < 2^31 */
    CmplxMag_T a = { In, Out, N, 1, 0, 15, 0 };
    RT_BENCH(CmplxMagSquared_Fix16(&a));
    rt_result("k09_cmplx_fix", rt_hash(Out, sizeof Out));
    return 0;
}
