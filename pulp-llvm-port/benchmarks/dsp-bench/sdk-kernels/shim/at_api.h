/* Shim replacing the SDK's at_api.h for the dsp-bench SDK-kernel benchmark (target builds).
 * It is the gap9-sweep shim (../../gap9-sweep/src/shim/at_api.h: one core, no PMSIS) plus the
 * few names the whole-file FFT/DFT libraries need that the sweep's kernels did not:
 *   - the L2<->L1 copy macros used by FFT_InstallTwiddlesAndSwapLUT (a plain memcpy here,
 *     same direction convention as the SDK's at_api_emul.h: dir 0 = ext -> loc);
 *   - a printf declaration for the DFT library's dead `if (TRACE) printf(...)` lines
 *     (TRACE is 0; clang 20 rejects the implicit declaration, GCC 7 only warns).
 * The SDK sources themselves are compiled unmodified. */
#pragma once
#include "../../../gap9-sweep/src/shim/at_api.h"
int printf(const char *, ...);
typedef unsigned int AT_L2_EVENT;
typedef char *AT_L2_EXT_ADDR_TYPE;
typedef char *AT_L2_INT_ADDR_TYPE;
#define AT_L2_COPY(dev, ext, loc, size, dir, event) \
    do { if (dir) memcpy((char *)(ext), (char *)(loc), (size)); else memcpy((char *)(loc), (char *)(ext), (size)); } while (0)
#define AT_L2_WAIT(dev, event) ((void)0)
