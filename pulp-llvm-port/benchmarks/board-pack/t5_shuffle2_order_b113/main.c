/* Test 5 (backlog B113): pv.shuffle2.b / pv.shuffle2.h source order.
 * pv.shuffle2 rD, rs1, rs2: each result lane picks a lane of {rD (old value), rs1}; the
 * selector's lane index is its low bits (2 for .b, 1 for .h), the next bit picks the source.
 * RI5CY manual / GAP9 GCC / patched GVSoC: bit clear -> rD, bit set -> rs1.
 * Stock SDK GVSoC (iss_v2): swapped (bit clear -> rs1, set -> rD).
 * Inline asm (GAP9 GCC assembles it) with rD = 0x44332211, rs1 = 0x88776655, then GCC's own
 * two-vector __builtin_shuffle is checked against a scalar reference. */
#include "pack.h"
#include <stdint.h>

static volatile uint32_t A = 0x44332211u, B = 0x88776655u;

typedef signed char v4s __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
static volatile v4s VA4 = { 0x11, 0x22, 0x33, 0x44 }, VB4 = { 0x55, 0x66, 0x77, 0x78 };
static volatile v2s VA2 = { 0x1111, 0x2222 }, VB2 = { 0x5555, 0x6666 };
__attribute__((noinline)) static uint32_t gb(void)
{ v4s r = __builtin_shuffle(VA4, VB4, (v4s){ 0, 4, 1, 5 }); union { v4s v; uint32_t u; } q = { r }; return q.u; }
__attribute__((noinline)) static uint32_t gh(void)
{ v2s r = __builtin_shuffle(VA2, VB2, (v2s){ 1, 2 }); union { v2s v; uint32_t u; } q = { r }; return q.u; }

static void run(void *arg)
{
    (void)arg;
    const char *core = pack_is_fc() ? "fc" : "cl";
    uint32_t b4 = 0, h4 = 0;
    for (unsigned v = 0; v < 8; v++) {
        uint32_t m = v | (v << 8) | (v << 16) | (v << 24);
        uint32_t rd = A, rs1 = B;
        __asm__ volatile("pv.shuffle2.b %0, %1, %2" : "+r"(rd) : "r"(rs1), "r"(m));
        uint32_t h = A, hs = B, mh = (v & 3) | ((v & 3) << 16);
        __asm__ volatile("pv.shuffle2.h %0, %1, %2" : "+r"(h) : "r"(hs), "r"(mh));
        printf("RESULT t5 core=%s sel=%u shuffle2.b=0x%08x shuffle2.h(sel&3)=0x%08x\n", core, v,
               (unsigned)rd, (unsigned)h);
        if (v == 4) b4 = rd;
        if (v == 2) h4 = h;      /* .h: sel 2 = source bit set, lane 0 */
    }
    const char *bv = b4 == 0x55555555u ? "bit set -> rs1 (RI5CY manual, GCC; GVSoC is wrong)"
                   : b4 == 0x11111111u ? "bit set -> rD (same as stock GVSoC; GCC's code would be wrong)" : "OTHER";
    const char *hv = h4 == 0x66556655u ? "bit set -> rs1 (RI5CY manual, GCC)"
                   : h4 == 0x22112211u ? "bit set -> rD (same as stock GVSoC)" : "OTHER";
    printf("VERDICT B113 pv.shuffle2.b on %s: %s\n", core, bv);
    printf("VERDICT B113 pv.shuffle2.h on %s: %s\n", core, hv);
    uint32_t g1 = gb(), g2 = gh();
    printf("RESULT t5 core=%s gcc_builtin_shuffle2.b {0,4,1,5}=0x%08x (C semantics 0x66225511) "
           "shuffle2.h {1,2}=0x%08x (C semantics 0x55552222)\n", core, (unsigned)g1, (unsigned)g2);
    char nm[48];
    /* PASS = same as the stock SDK GVSoC (gap.gap9.evk and ri5ky_testbench both swap the sources).
     * FAIL on silicon = silicon follows the manual/GCC and GVSoC is wrong (the expected outcome). */
    sprintf(nm, "t5.%s.shuffle2b_sel4_like_gvsoc", core);
    pack_check(nm, b4, 0x11111111u);
    sprintf(nm, "t5.%s.shuffle2h_sel2_like_gvsoc", core);
    pack_check(nm, h4, 0x22112211u);
    sprintf(nm, "t5.%s.gcc_shuffle2b_like_gvsoc", core);
    pack_check(nm, g1, 0x22661155u);
    sprintf(nm, "t5.%s.gcc_shuffle2h_like_gvsoc", core);
    pack_check(nm, g2, 0x11116666u);
}

int main(void)
{
    pack_banner("t5_shuffle2_order_b113");
    printf("INFO CHECK PASS = same as GVSoC. Expected on silicon: FAIL (silicon follows the RI5CY manual and GCC)\n");
    pack_run_on(PACK_ON_FC, run, 0);
    pack_run_on(PACK_ON_CLUSTER, run, 0);
    return pack_end("t5_shuffle2_order_b113");
}
