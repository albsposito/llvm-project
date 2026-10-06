/* Host (x86-64 gcc) replacement for the SDK's at_api.h, used ONLY for the host reference build
 * of the MFCC application. __EMUL__ is defined and __pulp__ is not, so the SDK's
 * Emulation/GapBuiltins.h and DSP_Libraries/FloatDefines.h select their plain-C branches.
 * The SDK's plain-C emulation macros (FloatDefines.h AbsF2/MaxF2) assume float16 and float16alt
 * are the same type, so the host build uses one 16-bit float type per variant: _Float16 (IEEE
 * half) for everything, or, with -DMFCC_F16A, __bf16 (bfloat16) for everything. gcc 13 has both. */
#pragma once
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
typedef signed short v2s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned char v4u __attribute__((vector_size(4)));
#ifdef MFCC_F16A
typedef __bf16 float16; typedef __bf16 float16alt;
#else
typedef _Float16 float16; typedef _Float16 float16alt;
#endif
typedef float16 v2h __attribute__((vector_size(4))); typedef float16alt v2ah __attribute__((vector_size(4)));
typedef v2s V2S; typedef float16 f16; typedef float16alt f16a;
#define gap_coreid() 0
#define gap_ncore() 1
#define gap_waitbarrier(x) ((void)0)
#define __GAP_H__ 1
#include "GapBuiltins.h"
#define L1_CL_MEM
#define L2_MEM
#define AT_L2_MEM
#define AT_NORM(x,n) gap_roundnorm_reg((x),(n))
/* L2 DMA-copy names used by FFT_InstallTwiddlesAndSwapLUT() (never called here) */
typedef int AT_L2_EVENT;
#define AT_L2_EXT_ADDR_TYPE void *
#define AT_L2_INT_ADDR_TYPE void *
#define AT_L2_COPY(dev, ext, loc, size, dir, evt) memcpy((loc), (ext), (size))
#define AT_L2_WAIT(dev, evt) ((void)0)
