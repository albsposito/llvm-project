/* Test 4 (backlog B114): which immediate bits of pv.shuffle.sci.h select each halfword lane?
 * rD.lane[i] = rs1.lane[sel_i]. The fork's LLVM and both GVSoC models read sel0 = imm bit 0,
 * sel1 = imm bit 1. GAP9 GCC encodes a constant v2s mask {1,1} as imm 17 (bit 0 + bit 4), i.e.
 * it assumes sel1 = imm bit 4. All 64 immediates are issued with inline asm (GAP9 GCC
 * assembles them) on rs1 = 0xBBBBAAAA, then the GCC-compiled __builtin_shuffle is run. */
#include "pack.h"
#include <stdint.h>

static volatile uint32_t X = 0xBBBBAAAAu;   /* lane0 = 0xAAAA, lane1 = 0xBBBB */
static uint32_t res[64];

#define S(i) { uint32_t r; __asm__ volatile("pv.shuffle.sci.h %0, %1, " #i : "=r"(r) : "r"(x)); res[i] = r; }

typedef short v2s __attribute__((vector_size(4)));
static volatile v2s VX = { 0x1111, 0x2222 };
__attribute__((noinline)) static uint32_t g11(void) { v2s r = __builtin_shuffle(VX, (v2s){1, 1}); union { v2s v; uint32_t u; } q = { r }; return q.u; }
__attribute__((noinline)) static uint32_t g10(void) { v2s r = __builtin_shuffle(VX, (v2s){1, 0}); union { v2s v; uint32_t u; } q = { r }; return q.u; }
__attribute__((noinline)) static uint32_t g00(void) { v2s r = __builtin_shuffle(VX, (v2s){0, 0}); union { v2s v; uint32_t u; } q = { r }; return q.u; }
/* run-time mask: pv.shuffle.h (register form), mask lanes {1,1} */
static volatile uint32_t MASK11 = 0x00010001u;
__attribute__((noinline)) static uint32_t reg11(void)
{ uint32_t r, x = 0xBBBBAAAAu, m = MASK11; __asm__ volatile("pv.shuffle.h %0, %1, %2" : "=r"(r) : "r"(x), "r"(m)); return r; }

static void run(void *arg)
{
    (void)arg;
    const char *core = pack_is_fc() ? "fc" : "cl";
    uint32_t x = X;
    S(0) S(1) S(2) S(3) S(4) S(5) S(6) S(7) S(8) S(9) S(10) S(11) S(12) S(13) S(14) S(15)
    S(16) S(17) S(18) S(19) S(20) S(21) S(22) S(23) S(24) S(25) S(26) S(27) S(28) S(29) S(30) S(31)
    S(32) S(33) S(34) S(35) S(36) S(37) S(38) S(39) S(40) S(41) S(42) S(43) S(44) S(45) S(46) S(47)
    S(48) S(49) S(50) S(51) S(52) S(53) S(54) S(55) S(56) S(57) S(58) S(59) S(60) S(61) S(62) S(63)
    for (int i = 0; i < 64; i += 8) {
        printf("RESULT t4 core=%s imm=%2d..%2d:", core, i, i + 7);
        for (int j = 0; j < 8; j++) printf(" %08x", (unsigned)res[i + j]);
        printf("\n");
    }
    /* which imm bit decides each lane? */
    int bit_of[2] = { -1, -1 }, clean = 1;
    for (int l = 0; l < 2; l++) {
        for (int b = 0; b < 6; b++) {
            int match = 1;
            for (int i = 0; i < 64; i++) {
                uint32_t lane = (res[i] >> (16 * l)) & 0xffff;
                uint32_t want = ((i >> b) & 1) ? 0xBBBB : 0xAAAA;
                if (lane != want) { match = 0; break; }
            }
            if (match) { bit_of[l] = b; break; }
        }
        if (bit_of[l] < 0) clean = 0;
    }
    printf("VERDICT B114 pv.shuffle.sci.h on %s: lane0 selector = imm bit %d, lane1 selector = imm bit %d%s\n",
           core, bit_of[0], bit_of[1], clean ? "" : " (-1 = no single bit explains the lane: see RESULT rows)");
    printf("VERDICT B114 meaning: lane1 bit 1 = LLVM/GVSoC encoding is right, GCC wrong; "
           "lane1 bit 4 = GCC right, LLVM/GVSoC wrong\n");
    uint32_t a = g11(), b = g10(), c = g00(), r = reg11();
    printf("RESULT t4 core=%s gcc_builtin_shuffle v={0x1111,0x2222}: {1,1}=0x%08x (want 0x22222222) "
           "{1,0}=0x%08x (want 0x11112222) {0,0}=0x%08x (want 0x11111111)\n", core,
           (unsigned)a, (unsigned)b, (unsigned)c);
    printf("RESULT t4 core=%s pv.shuffle.h reg mask {1,1} on 0xBBBBAAAA = 0x%08x (want 0xbbbbbbbb)\n", core, (unsigned)r);
    char nm[48];
    /* PASS = same as GVSoC */
    sprintf(nm, "t4.%s.sel_bits_like_gvsoc", core);
    pack_check(nm, (uint32_t)(bit_of[0] | (bit_of[1] << 8)), 0x0100);
    sprintf(nm, "t4.%s.gcc_shuffle11_like_gvsoc", core);
    pack_check(nm, a, 0x11112222);
    sprintf(nm, "t4.%s.reg_shuffle_h", core);
    pack_check(nm, r, 0xbbbbbbbb);
}

int main(void)
{
    pack_banner("t4_shuffle_sci_h_b114");
    pack_run_on(PACK_ON_FC, run, 0);
    pack_run_on(PACK_ON_CLUSTER, run, 0);
    return pack_end("t4_shuffle_sci_h_b114");
}
