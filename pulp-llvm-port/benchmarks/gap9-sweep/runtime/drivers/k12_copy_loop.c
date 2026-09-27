/* k12 anchor copy_loop: d[i] = a[i] + 7 over 4096 uint32. */
#include "rt.h"
typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
extern void copy_loop(unsigned *restrict d, const unsigned *restrict a, unsigned n);
#define N 4096
static uint32_t A[N], D[N];
int main(void)
{
    uint32_t n = rt_n(N);
    rt_seed(0x1012u); rt_fill_u32(A, n);
    RT_BENCH(copy_loop(D, A, n));
    rt_result("k12_copy_loop", rt_hash(D, sizeof D));
    return 0;
}
