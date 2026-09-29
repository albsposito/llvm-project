/* GAP9 board test pack: shared helpers. See pack.h. */
#include "pack.h"

volatile int pack_pass, pack_fail;

void pack_banner(const char *test)
{
    printf("\n=== BOARD-PACK %s (pack %s) ===\n", test, PACK_VERSION);
    printf("INFO compiler of this file: %s\n", __VERSION__);
#if defined(__PLATFORM_GVSOC__)
    printf("INFO platform: GVSoC (built with CONFIG_PLATFORM_GVSOC2)\n");
#elif defined(__PLATFORM_BOARD__)
    printf("INFO platform: board\n");
#else
    printf("INFO platform: __PLATFORM__=%d\n", (int)__PLATFORM__);
#endif
}

int pack_end(const char *test)
{
    printf("=== END %s pass=%d fail=%d\n", test, pack_pass, pack_fail);
    return pack_fail ? 1 : 0;
}

int pack_check(const char *name, uint32_t got, uint32_t want)
{
    int ok = got == want;
    if (ok) pack_pass++; else pack_fail++;
    printf("CHECK %s %s got=0x%08x want=0x%08x\n", name, ok ? "PASS" : "FAIL",
           (unsigned)got, (unsigned)want);
    return ok;
}

int pack_is_fc(void) { return pi_is_fc(); }

const char *pack_where_name(pack_where_t where)
{
    return where == PACK_ON_FC ? "FC" : "cluster-controller";
}

typedef struct { void (*fn)(void *); void *arg; } pack_cl_call_t;

static void pack_cl_entry(void *p)
{
    pack_cl_call_t *c = (pack_cl_call_t *)p;
    printf("INFO cluster task runs on cluster %d core %d (the cluster controller)\n",
           (int)pi_cluster_id(), (int)pi_core_id());
    c->fn(c->arg);
}

int pack_run_on_cluster(void (*fn)(void *), void *arg)
{
    struct pi_device cluster_dev;
    struct pi_cluster_conf conf;
    struct pi_cluster_task task;
    pack_cl_call_t call = { fn, arg };

    pi_cluster_conf_init(&conf);
    conf.id = 0;
    pi_open_from_conf(&cluster_dev, &conf);
    if (pi_cluster_open(&cluster_dev)) {
        printf("INFO cluster open FAILED\n");
        return -1;
    }
    pi_cluster_task(&task, pack_cl_entry, &call);
    pi_cluster_send_task_to_cl(&cluster_dev, &task);
    pi_cluster_close(&cluster_dev);
    return 0;
}

int pack_run_on(pack_where_t where, void (*fn)(void *), void *arg)
{
    if (where == PACK_ON_FC) { fn(arg); return 0; }
    return pack_run_on_cluster(fn, arg);
}

/* The core's own performance counters (PCCR CSRs), used directly instead of pi_perf_reset()/
 * pi_perf_start(): on the cluster controller those also program the cluster timer, which GVSoC does
 * not model (the simulated run stops with "Invalid access ... 0x10200420"). The counters used
 * here are the ones pi_perf_read(PI_PERF_ACTIVE_CYCLES / PI_PERF_INSTR) returns. */
void pack_perf_start(void)
{
    __pi_perf_mask_events_set((1 << PI_PERF_ACTIVE_CYCLES) | (1 << PI_PERF_INSTR));
    __pi_perf_counters_reset();
    __pi_perf_counter_enable(CSR_PCMR_ENABLE | CSR_PCMR_SATURATE);
}

uint32_t pack_perf_cycles(void) { return __pi_perf_counter_get(PI_PERF_ACTIVE_CYCLES); }
uint32_t pack_perf_instr(void) { return __pi_perf_counter_get(PI_PERF_INSTR); }
