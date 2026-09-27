/* k11 dotprod_i8: 1024 int8 x int8 (256 x v4s) via gap_sumdotp4. */
#include "rt.h"
typedef signed char v4s __attribute__((vector_size(4)));
extern int dotprod_i8(const v4s *__restrict__ A, const v4s *__restrict__ B, int N);
#define N 1024
static int8_t A[N] __attribute__((aligned(4))), B[N] __attribute__((aligned(4)));
static volatile int sink;
int main(void)
{
    uint32_t n = rt_n(N);
    rt_seed(0x100bu); rt_fill_i8(A, n, -128, 127);
    rt_seed(0x200bu); rt_fill_i8(B, n, -128, 127);
    int r = 0;
    RT_BENCH(r = dotprod_i8((const v4s *)A, (const v4s *)B, N / 4));
    sink = r;
    rt_result("k11_dotprod_i8", rt_hash(&r, sizeof r));
    return 0;
}
