/* Test 1 (backlog B101): GAP9 GCC hardware-loop bug on silicon.
 * The same two functions are compiled five times with different GCC options (CMakeLists.txt)
 * and called with the loop count in a volatile, so it is only known at run time.
 * Expected on a correct compiler: checksum = 0x40, kern = 0x4c for every variant.
 * GAP9 GCC 7.1.1 on GVSoC: -O2 and -O3 give 0x4b / 0x4a (loop body runs once). */
#include "pack.h"

#define DECL(v) unsigned checksum_##v(const unsigned char *, unsigned, unsigned); \
                unsigned kern_##v(unsigned *, unsigned, unsigned);
DECL(Os) DECL(O2) DECL(O2_nohwloop) DECL(O3) DECL(O3_nohwloop)

unsigned char data[4] = {1, 2, 3, 4};
volatile unsigned vlen = 4, vrounds = 3;   /* issue-standalone.c */
volatile unsigned vn = 4, vk = 3;          /* issue-standalone-gvsoc.c */

typedef struct {
    const char *name, *flags;
    unsigned (*checksum)(const unsigned char *, unsigned, unsigned);
    unsigned (*kern)(unsigned *, unsigned, unsigned);
    int bug_expected;   /* what GVSoC showed for GAP9 GCC 7.1.1 */
} variant_t;

static const variant_t variants[] = {
    { "Os",          "-Os (SDK default)",       checksum_Os,          kern_Os,          0 },
    { "O2",          "-O2",                     checksum_O2,          kern_O2,          1 },
    { "O2_nohwloop", "-O2 -mnohwloop",          checksum_O2_nohwloop, kern_O2_nohwloop, 0 },
    { "O3",          "-O3",                     checksum_O3,          kern_O3,          1 },
    { "O3_nohwloop", "-O3 -mnohwloop",          checksum_O3_nohwloop, kern_O3_nohwloop, 0 },
};

static void run_all(void *arg)
{
    (void)arg;
    int reproduced = 0, expected = 0;
    printf("INFO running on %s\n", pack_is_fc() ? "FC" : "the cluster controller core");
    for (unsigned i = 0; i < sizeof variants / sizeof variants[0]; i++) {
        const variant_t *v = &variants[i];
        unsigned c = v->checksum(data, vlen, vrounds);
        unsigned k = v->kern(0, vn, vk);
        printf("RESULT t1 variant=%s flags=\"%s\" checksum=0x%x kern=0x%x\n", v->name, v->flags, c, k);
        char n1[48], n2[48];
        sprintf(n1, "t1.%s.%s.checksum", pack_is_fc() ? "fc" : "cl", v->name);
        sprintf(n2, "t1.%s.%s.kern", pack_is_fc() ? "fc" : "cl", v->name);
        /* PASS = the silicon result equals the simulator result for this variant.
         * For the buggy variants the simulator (and the bug) give 0x4b / 0x4a. */
        pack_check(n1, c, v->bug_expected ? 0x4b : 0x40);
        pack_check(n2, k, v->bug_expected ? 0x4a : 0x4c);
        if (c != 0x40 || k != 0x4c) reproduced++;
        expected += v->bug_expected;
    }
    printf("VERDICT B101 GCC hwloop bug on %s: %s (%d wrong variants, simulator had %d)\n",
           pack_is_fc() ? "FC" : "cluster", reproduced ? "REPRODUCED (wrong results)" : "NOT reproduced",
           reproduced, expected);
}

int main(void)
{
    pack_banner("t1_b101_gcc_hwloop");
    printf("INFO correct values: checksum=0x40 kern=0x4c; a CHECK PASS means 'same as GVSoC'\n");
    pack_run_on(PACK_ON_FC, run_all, 0);
    pack_run_on(PACK_ON_CLUSTER, run_all, 0);
    return pack_end("t1_b101_gcc_hwloop");
}
