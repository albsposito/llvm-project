/* Kernel 4: MatMulSimpleSeq (fp32 triple loop).
 * Extracted verbatim by run.py from examples/gap9/dsp/benchmarks/MatMul/MatMulRunTest.c
 * (leading 'static' dropped). The FC timer read is replaced by a constant. */
#include "at_api.h"
#define gap_fc_readhwtimer() 0
#include "k04_matmul_simple_f32.extract.c"
