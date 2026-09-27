/* k06 KerParMatVectDSP_f32: Out[64] = In2[64x256] x In1[256], fp32 (zfinx). */
#include "rt.h"
typedef struct { void *__restrict__ In1; void *__restrict__ In2; void *__restrict__ Out;
                 unsigned int InDim; unsigned int OutDim; int Norm; } MatVect_DSP_T;
extern void KerParMatVectDSP_f32(MatVect_DSP_T *Arg);
#define IN 256
#define OUT 64
static float In1[IN], In2[OUT * IN], Out[OUT];
int main(void)
{
    rt_seed(0x1006u); rt_fill_f32(In1, rt_n(IN));
    rt_seed(0x2006u); rt_fill_f32(In2, rt_n(OUT * IN));
    MatVect_DSP_T a = { In1, In2, Out, IN, OUT, 0 };
    RT_BENCH(KerParMatVectDSP_f32(&a));
    rt_result("k06_matvect_dsp_f32", rt_hash(Out, sizeof Out));
    rt_dump_f32(Out, rt_n(OUT));
    return 0;
}
