/* GAP9 board test pack: shared helpers (PMSIS, built with the SDK's normal CMake flow).
 *
 * Every test prints lines that start with a fixed tag, so that scripts/collect_results.sh
 * (and a human) can grep them:
 *   "=== BOARD-PACK <test> ..."     banner, one per test run
 *   "INFO ..."                      context (core, compiler, addresses)
 *   "RESULT <test> <key>=<value>"   a measured value to compare with the simulator
 *   "CHECK <name> PASS|FAIL ..."    a self-checked value
 *   "VERDICT <question>: <answer>"  the conclusion the test draws from its own values
 *   "=== END <test> pass=N fail=M"  last line; missing = the test hung or crashed
 */
#ifndef BOARD_PACK_H
#define BOARD_PACK_H

#include "pmsis.h"
#include <stdint.h>

#define PACK_VERSION "2026-09-29"

/* Where a probe runs: on the fabric controller or on the cluster controller core. */
typedef enum { PACK_ON_FC = 0, PACK_ON_CLUSTER = 1 } pack_where_t;

void pack_banner(const char *test);
/* Last line of every test. Returns the value main() should return (0 = all PASS). */
int pack_end(const char *test);
/* Record a self-check. Prints "CHECK <name> PASS|FAIL got=0x.. want=0x..". */
int pack_check(const char *name, uint32_t got, uint32_t want);
/* Counts of pack_check() results so far. */
extern volatile int pack_pass, pack_fail;

/* Run fn(arg) on the cluster controller core (the core a cluster task starts on). Opens and closes the cluster.
 * Returns 0 on success, -1 if the cluster could not be opened. */
int pack_run_on_cluster(void (*fn)(void *), void *arg);
/* Run fn(arg) on the requested core (FC: direct call). */
int pack_run_on(pack_where_t where, void (*fn)(void *), void *arg);
const char *pack_where_name(pack_where_t where);
/* 1 if the caller runs on the fabric controller. */
int pack_is_fc(void);

/* Cycle / instruction counters of the calling core (PCCR CSRs: PI_PERF_ACTIVE_CYCLES and
 * PI_PERF_INSTR). pack_perf_start() resets and starts them; pack_perf_cycles()/
 * pack_perf_instr() read them without stopping. */
void pack_perf_start(void);
uint32_t pack_perf_cycles(void);
uint32_t pack_perf_instr(void);

#endif
