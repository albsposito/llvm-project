/* k04 MatMulSimpleSeq (SDK MatMul benchmark, fp32 triple loop, Zfinx): Out[32x32] = M1[32x32] x M2[32x32],
 * non-transposed path (Transposed read from a volatile, 0). Values in [-1,1). Output dumped (OUTF)
 * for the fp32 tolerance check. The kernel's FC timer read is a constant in the sweep TU. */
#include "rt.h"
extern int MatMulSimpleSeq(float *M1, float *M2, float *Out, int H1, int W1, int W2, int Transposed);
#define M 32
static float M1[M * M], M2[M * M], Out[M * M];
int main(void)
{
    rt_seed(0x1004u); rt_fill_f32(M1, rt_n(M * M));
    rt_seed(0x2004u); rt_fill_f32(M2, rt_n(M * M));
    int h1 = rt_n(M), w1 = rt_n(M), w2 = rt_n(M), tr = rt_n(0);
    RT_BENCH(MatMulSimpleSeq(M1, M2, Out, h1, w1, w2, tr));
    rt_result("k04_matmul_simple_f32", rt_hash(Out, sizeof Out));
    rt_dump_f32(Out, rt_n(M * M));
    return 0;
}
