/* k05 KerParMatMulDSP_Fix16: Out[32x32] (int16) = clip16(roundnorm(In1[32x32] x In2[32x32], 11)).
 * Inputs in [-4096,4095]: sums < 2^29 (no int32 overflow). After >>11, 35/1024 outputs exceed
 * the int16 range (real saturation) and 283/1024 lie outside [-16384,16383], i.e. are clamped
 * wrongly if gap_clip(x,15) is encoded p.clip ...,15 (LLVM) instead of ...,16 (GCC). */
#include "rt.h"
typedef struct {
    void *__restrict__ In1; void *__restrict__ In2; void *__restrict__ Out; void *BufferColIn2;
    unsigned int W_In1, H_In1, W_In2, W_Out, OutFirstCol; int ColFirst; int Norm;
} MatMul_DSP_T;
extern void KerParMatMulDSP_Fix16(MatMul_DSP_T *Arg);
#define M 32
static int16_t In1[M * M], In2[M * M], Out[M * M], Buf[4 * M];
int main(void)
{
    uint32_t n = rt_n(M * M);
    rt_seed(0x1005u); rt_fill_i16(In1, n, -4096, 4095);
    rt_seed(0x2005u); rt_fill_i16(In2, n, -4096, 4095);
    MatMul_DSP_T a = { In1, In2, Out, Buf, M, M, M, M, 0, 0, 11 };
    RT_BENCH(KerParMatMulDSP_Fix16(&a));
    rt_result("k05_matmul_dsp_fix16", rt_hash(Out, sizeof Out));
    return 0;
}
