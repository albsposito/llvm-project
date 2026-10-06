/* Host (x86-64 gcc) replacement for ../shim/at_api.h, used ONLY for the host reference build.
 * Same idea as gap9-sweep/runtime/hostshim/at_api.h: __EMUL__ is defined and __pulp__ is not,
 * so the SDK's Emulation/GapBuiltins.h and DSP_Libraries/FloatDefines.h select their plain-C
 * branches for every gap_* / Min / Max / Abs macro. Differences from the sweep's host shim:
 *   - float16 is _Float16 (IEEE binary16) and float16alt is __bf16 (bfloat16), so that the f16
 *     and f16alt kernels are computed in the real 16-bit formats (x86 gcc 13 rounds every
 *     + - * to the 16-bit format; it does not fuse multiply-adds);
 *   - the L2 copy macros and printf, as in ../shim/at_api.h. */
#pragma once
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
typedef signed short v2s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned char v4u __attribute__((vector_size(4)));
typedef _Float16 float16; typedef __bf16 float16alt;
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
typedef unsigned int AT_L2_EVENT;
typedef char *AT_L2_EXT_ADDR_TYPE;
typedef char *AT_L2_INT_ADDR_TYPE;
#define AT_L2_COPY(dev, ext, loc, size, dir, event) \
    do { if (dir) memcpy((char *)(ext), (char *)(loc), (size)); else memcpy((char *)(loc), (char *)(ext), (size)); } while (0)
#define AT_L2_WAIT(dev, event) ((void)0)
