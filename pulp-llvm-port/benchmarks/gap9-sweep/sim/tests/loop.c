#include "bench.h"
#define N 1000
static volatile int32_t sink;
static volatile int32_t vn = N; /* defeat constant folding of work(N) */
static int32_t data[N];
/* 1000-iteration integer loop over an array. (A pure-arithmetic loop with a
 * runtime trip count, repro/hwloop_var_tripcount_crash.c, crashes port-20
 * clang in the PULP Hardware Loops pass.) */
__attribute__((noinline)) static int32_t work(const int32_t *p, int32_t n)
{
    int32_t acc = 0;
    for (int32_t i = 0; i < n; i++) acc += p[i] ^ (acc >> 3);
    return acc;
}
int main(void)
{
    for (int32_t i = 0; i < N; i++) data[i] = i * 7 + 1;
    for (int r = 0; r < 3; r++) {
        uint32_t p0 = bench_pccr_cycles(), i0 = bench_pccr_instr();
        int32_t n = vn;
        uint64_t t0 = bench_cycles();
        sink = work(data, n);
        uint64_t t1 = bench_cycles();
        uint32_t p1 = bench_pccr_cycles(), i1 = bench_pccr_instr();
        bench_puts("run "); bench_print_u32(r);
        bench_puts(": mmio_cycles="); bench_print_u64(t1 - t0);
        bench_puts(" pccr_cycles="); bench_print_u32(p1 - p0);
        bench_puts(" pccr_instr="); bench_print_u32(i1 - i0);
        bench_puts(" result="); bench_print_i32(sink);
        bench_putchar('\n');
    }
    return 0;
}
