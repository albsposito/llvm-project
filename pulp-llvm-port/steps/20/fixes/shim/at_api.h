#pragma once
#include <stdint.h>
#include <string.h>
typedef signed short v2s __attribute__((vector_size(4)));  /* + v2u, v4s, v4u */
#ifdef __clang__
typedef _Float16 float16; typedef _Float16 float16alt;      /* float16alt is WRONG (bf16): compile probing only */
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
