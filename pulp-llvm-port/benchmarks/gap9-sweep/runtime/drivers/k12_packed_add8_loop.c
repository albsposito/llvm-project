/* k12 anchor packed_add8_loop: d = a + b over 1024 v4u. */
#include "rt.h"
typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
extern void packed_add8_loop(v4u *restrict d, const v4u *restrict a, const v4u *restrict b, unsigned n);
#define N 1024
static uint32_t A[N], B[N], D[N];
int main(void)
{
    uint32_t n = rt_n(N);
    rt_seed(0x1012u); rt_fill_u32(A, n);
    rt_seed(0x2012u); rt_fill_u32(B, n);
    RT_BENCH(packed_add8_loop((v4u *)D, (const v4u *)A, (const v4u *)B, n));
    rt_result("k12_packed_add8_loop", rt_hash(D, sizeof D));
    return 0;
}
