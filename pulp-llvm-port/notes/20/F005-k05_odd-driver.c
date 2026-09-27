/* F005 variant of drivers/k05_matmul_dsp_fix16.c: odd W_In1/H_In1 so the (W_In1&1) tail
 * and the odd last row run (the paths through the rotated hardware-loop latch), and small
 * inputs so no output leaves [-16384,16383] (keeps the known p.clip bug out of the checksum). */
#include "rt.h"
typedef struct {
    void *__restrict__ In1; void *__restrict__ In2; void *__restrict__ Out; void *BufferColIn2;
    unsigned int W_In1, H_In1, W_In2, W_Out, OutFirstCol; int ColFirst; int Norm;
} MatMul_DSP_T;
extern void KerParMatMulDSP_Fix16(MatMul_DSP_T *Arg);
#ifndef W1
#define W1 31
#endif
#ifndef H1
#define H1 31
#endif
#define W2 32
static int16_t In1[H1 * W1], In2[W1 * W2], Out[H1 * W2], Buf[4 * W1];
int main(void)
{
    rt_seed(0x1005u); rt_fill_i16(In1, rt_n(H1 * W1), -512, 511);
    rt_seed(0x2005u); rt_fill_i16(In2, rt_n(W1 * W2), -512, 511);
    MatMul_DSP_T a = { In1, In2, Out, Buf, rt_n(W1), rt_n(H1), rt_n(W2), W2, 0, 0, 11 };
    RT_BENCH(KerParMatMulDSP_Fix16(&a));
    rt_result("k05_odd", rt_hash(Out, sizeof Out));
    return 0;
}
