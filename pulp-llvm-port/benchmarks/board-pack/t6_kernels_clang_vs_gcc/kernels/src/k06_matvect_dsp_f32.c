/* k06_matvect_dsp_f32: fixed-point / fp32 kernel extracted verbatim by run.py from the SDK
 * DSP library into build/gen/ (see run.py KERNELS for the source and function
 * names). The whole SDK file cannot be compiled by clang for reasons unrelated
 * to this kernel (fp16 helpers / DMA types); the whole-file status is recorded
 * as a separate '-file' row. gap_ncore() is 1 via the shim. */
#include "at_api.h"
#include "DspLib.h"
#include "k06_matvect_dsp_f32.extract.c"
