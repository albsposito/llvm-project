/* k03 matmul_worker: C[32x32] (int32) = A[32x32] (int16) x B[32x32] (int16), single core. */
#include "rt.h"
typedef struct { int16_t *a; int16_t *b; int32_t *c; int rows; int k; int n; } worker_args_t;
extern void matmul_worker(void *arg);
#define M 32
static int16_t A[M * M], B[M * M];
static int32_t C[M * M];
int main(void)
{
    uint32_t n = rt_n(M * M);
    rt_seed(0x1003u); rt_fill_i16(A, n, -2048, 2047);   /* |sum| < 2^27: no int32 overflow */
    rt_seed(0x2003u); rt_fill_i16(B, n, -2048, 2047);
    worker_args_t w = { A, B, C, M, M, M };
    RT_BENCH(matmul_worker(&w));
    rt_result("k03_matmul_worker_i16", rt_hash(C, sizeof C));
    return 0;
}
