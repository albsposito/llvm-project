/* k12 anchor dot16_loop: sdotsp2 over 1024 v2s (int16 in [-2048,2047]: no int32 overflow). */
#include "rt.h"
typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
extern int dot16_loop(const v2s *a, const v2s *b, unsigned n);
#define N 1024
static int16_t A[2 * N] __attribute__((aligned(4))), B[2 * N] __attribute__((aligned(4)));
int main(void)
{
    uint32_t n = rt_n(N); int r = 0;
    rt_seed(0x1012u); rt_fill_i16(A, 2 * n, -2048, 2047);
    rt_seed(0x2012u); rt_fill_i16(B, 2 * n, -2048, 2047);
    RT_BENCH(r = dot16_loop((const v2s *)A, (const v2s *)B, n));
    rt_result("k12_dot16_loop", rt_hash(&r, sizeof r));
    return 0;
}
