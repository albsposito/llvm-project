/* Target shim for the MFCC application: the gap9-sweep shim (benchmarks/gap9-sweep/src/shim/at_api.h)
 * plus the L2 DMA-copy names that FftLibrary*.c uses in FFT_InstallTwiddlesAndSwapLUT().
 * That function (a cluster L2 -> L1 table copy) is never called here; the stubs only let the
 * unmodified SDK file compile. */
#pragma once
#include "../../../gap9-sweep/src/shim/at_api.h"
typedef int AT_L2_EVENT;
#define AT_L2_EXT_ADDR_TYPE void *
#define AT_L2_INT_ADDR_TYPE void *
#define AT_L2_COPY(dev, ext, loc, size, dir, evt) memcpy((loc), (ext), (size))
#define AT_L2_WAIT(dev, evt) ((void)0)
