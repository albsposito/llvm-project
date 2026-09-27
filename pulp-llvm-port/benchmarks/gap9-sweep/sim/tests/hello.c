#include "bench.h"
int main(void)
{
    uint64_t t0 = bench_cycles();
    bench_puts("Hello from ri5ky_testbench (bare-metal)\n");
    uint64_t t1 = bench_cycles();
    bench_puts("cycles for puts: "); bench_print_u64(t1 - t0); bench_putchar('\n');
    bench_puts("cycle counter now: "); bench_print_u64(bench_cycles()); bench_putchar('\n');
    return 0;
}
