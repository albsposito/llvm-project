/* Test 6: our clang vs GAP9 GCC on real kernels, on silicon.
 * The kernel library (12 kernels + their drivers from benchmarks/gap9-sweep, built by ONE
 * compiler: see kernels/build_kernels.sh) is linked into this PMSIS app (built by GAP9 GCC
 * through the SDK). Each driver fills its inputs, runs the kernel once untimed, then RT_REPS=4
 * timed calls, and prints "RESULT t6 core=.. lib=.. kernel=.. cycles=<per call> checksum=..".
 * Checksums must equal the GAP9 GCC -O2 reference from the GVSoC sweep for every compiler and
 * every core (CHECK lines). Cycles come from the core's PCCR counters (active cycles). The
 * whole list runs on the FC, then on the cluster controller core (data in L2 in both cases). */
#include "pack.h"
#include <stdint.h>
#include <string.h>

typedef struct { const char *name; int (*main)(void); } pack_kernel_t;
extern const pack_kernel_t pack_kernels[];
extern const int pack_nkernels;
extern const char pack_kernels_lib[], pack_kernels_id[];

/* GAP9 GCC -O2 checksums on GVSoC (benchmarks/gap9-sweep/runtime/runtime_results.json); every
 * correct build (GCC -O2/-O3, port20fix2 -O2/-O3, host) gives the same value. */
static const struct { const char *k; uint32_t cks; uint32_t sim_gcc_o2_cycles; } ref[] = {
    { "k01_fir_fix16",          0x0b3c9219u,  17074 },
    { "k02_fir_f32",            0x1e0987a3u,  42411 },
    { "k03_matmul_worker_i16",  0xae63bc89u, 146009 },
    { "k04_matmul_simple_f32",  0x39339370u, 143874 },
    { "k05_matmul_dsp_fix16",   0x56c64fd1u,  42748 },
    { "k06_matvect_dsp_f32",    0xbf3cac76u,  50290 },
    { "k09_cmplx_fix",          0x53d098a0u,   2067 },
    { "k10a_fft_radix2_scalar", 0xdeebe4e7u,  23069 },
    { "k11_dotprod_i8",         0x8bcd1bceu,   1046 },
    { "clip",                   0x5ec4255du,  17437 },
    { "k12_dot16_loop",         0x90e2a3b2u,   4117 },
    { "k12_copy_loop",          0xcf418d3bu,  16402 },
};
#define NREF (sizeof ref / sizeof ref[0])

static char tag[64];
static const char *core_name;
uint32_t pack_k_cycles(void) { return pack_perf_cycles(); }
uint32_t pack_k_instr(void) { return pack_perf_instr(); }
void pack_k_puts(const char *s) { printf("%s", s); }
void pack_k_u32(uint32_t v) { printf("%u", (unsigned)v); }
void pack_k_hex(uint32_t v) { printf("0x%08x", (unsigned)v); }
const char *pack_k_tag(void) { return tag; }
void pack_k_abort(int code) { printf("INFO kernel driver aborted with code %d\n", code); pmsis_exit(code); for (;;); }
void pack_k_result(const char *kernel, uint32_t checksum, uint32_t cycles, uint32_t instrs)
{
    (void)cycles; (void)instrs;
    for (unsigned i = 0; i < NREF; i++)
        if (!strcmp(ref[i].k, kernel)) {
            char nm[80];
            sprintf(nm, "t6.%s.%s.%s", core_name, pack_kernels_lib, kernel);
            pack_check(nm, checksum, ref[i].cks);
            return;
        }
    printf("INFO no reference checksum for %s\n", kernel);
}

static void run(void *arg)
{
    (void)arg;
    core_name = pack_is_fc() ? "fc" : "cl";
    sprintf(tag, "core=%s lib=%s", core_name, pack_kernels_lib);
    printf("INFO running %d kernels on %s\n", pack_nkernels, pack_is_fc() ? "FC" : "the cluster controller core");
    pack_perf_start();
    for (int i = 0; i < pack_nkernels; i++) pack_kernels[i].main();
}

int main(void)
{
    pack_banner("t6_kernels_clang_vs_gcc");
    printf("INFO kernel library: %s\n", pack_kernels_id);
    printf("INFO kernels in the library: %d of %d\n", pack_nkernels, (int)NREF);
    pack_run_on(PACK_ON_FC, run, 0);
    pack_run_on(PACK_ON_CLUSTER, run, 0);
    return pack_end("t6_kernels_clang_vs_gcc");
}
