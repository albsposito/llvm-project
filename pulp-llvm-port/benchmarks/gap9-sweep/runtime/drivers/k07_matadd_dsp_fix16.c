/* k07 KerParMatAdd_DSP_Fix16: Out[32x32] int16 = clip16(roundnorm(In1 + In2, 1)).
 * Full-range int16 inputs: (In1+In2) roundnorm 1 always fits int16, but about half the outputs lie
 * outside [-16384,16383], so a gap_clip(x,15) encoded p.clip ...,15 (the LLVM off-by-one, see k05)
 * would show up as a wrong result. */
#include "rt.h"
typedef struct { void *__restrict__ In1; void *__restrict__ In2; void *__restrict__ Out;
                 unsigned short W, H, Norm; } KerMatAdd_DSP_T;
extern void KerParMatAdd_DSP_Fix16(KerMatAdd_DSP_T *Arg);
#define M 32
static int16_t In1[M * M], In2[M * M], Out[M * M];
int main(void)
{
    uint32_t n = rt_n(M * M);
    rt_seed(0x1007u); rt_fill_i16(In1, n, -32768, 32767);
    rt_seed(0x2007u); rt_fill_i16(In2, n, -32768, 32767);
    KerMatAdd_DSP_T a = { In1, In2, Out, M, M, 1 };
    RT_BENCH(KerParMatAdd_DSP_Fix16(&a));
    rt_result("k07_matadd_dsp_fix16", rt_hash(Out, sizeof Out));
    return 0;
}
