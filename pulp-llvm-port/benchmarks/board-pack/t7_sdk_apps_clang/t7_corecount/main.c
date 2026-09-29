/* Test 7c (backlog B107): how many cluster cores does a cluster team fork really start?
 * Prints what __builtin_pulp_CoreCount() and pi_cl_cluster_nb_cores() return on the cluster,
 * then forks a team of pi_cl_cluster_nb_cores() cores (as the SDK helloworld does) and counts
 * the cores that ran. GAP9 GCC: 8. Our clang before task 20/F018: the builtin reads the wrong
 * register and returns 0, so the fork runs on NO core (helloworld then silently skips its
 * per-core prints). Built with our clang + the CoreCount workaround header: 8. */
#include "pack.h"

static volatile int ran[16];
static volatile int nb_builtin, nb_api;

static void pe_entry(void *arg)
{
    (void)arg;
    ran[pi_core_id() & 15] = 1;
    printf("[%d %d] Hello from a cluster core\n", (int)pi_cluster_id(), (int)pi_core_id());
}

static void cl_entry(void *arg)
{
    (void)arg;
    nb_builtin = __builtin_pulp_CoreCount();
    nb_api = pi_cl_cluster_nb_cores();
    pi_cl_team_fork(pi_cl_cluster_nb_cores(), pe_entry, 0);
}

int main(void)
{
    pack_banner("t7_corecount_b107");
    if (pack_run_on_cluster(cl_entry, 0)) return pack_end("t7_corecount_b107");
    int n = 0;
    for (int i = 0; i < 16; i++) n += ran[i];
    printf("RESULT t7 __builtin_pulp_CoreCount()=%d pi_cl_cluster_nb_cores()=%d cores_that_ran=%d\n",
           nb_builtin, nb_api, n);
    printf("VERDICT B107 cluster team fork: %s\n",
           n == 8 ? "8 cores ran (correct)" : n == 0 ? "NO core ran (the B107 CoreCount bug)" : "unexpected core count");
    pack_check("t7.cores_that_ran", (uint32_t)n, 8);
    return pack_end("t7_corecount_b107");
}
