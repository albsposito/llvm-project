/* k12 anchor sum_loop: sum of 4096 uint32. */
#include "rt.h"
typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
extern unsigned sum_loop(const unsigned *a, unsigned n);
#define N 4096
static uint32_t A[N];
int main(void)
{
    uint32_t n = rt_n(N), r = 0;
    rt_seed(0x1012u); rt_fill_u32(A, n);
    RT_BENCH(r = sum_loop(A, n));
    rt_result("k12_sum_loop", rt_hash(&r, sizeof r));
    return 0;
}
