/* Kernel 3: matmul_worker (int16 -> int32), single core.
 * The function is extracted verbatim by run.py from
 * examples/gap9/basic/getting_started/cluster_kernels.c into build/gen/ (only its
 * leading 'static' is dropped so the symbol is emitted). The PMSIS core queries
 * are replaced by single-core constants here. */
#include "at_api.h"
#define pi_core_id() 0
#define pi_cl_cluster_nb_cores() 1
#include "k03_matmul_worker_i16.extract.c"
