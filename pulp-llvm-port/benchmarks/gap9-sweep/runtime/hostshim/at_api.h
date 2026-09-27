/* Host (x86-64 gcc) replacement for ../../src/shim/at_api.h, used ONLY for the host-side
 * reference build. Same typedefs, but __EMUL__ is defined and __pulp__ is not, so the SDK's
 * Emulation/GapBuiltins.h selects its plain-C emulation branch for every gap_* macro. */
#pragma once
#include <stdint.h>
#include <string.h>
typedef signed short v2s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned char v4u __attribute__((vector_size(4)));
typedef _Float16 float16; typedef _Float16 float16alt;
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
