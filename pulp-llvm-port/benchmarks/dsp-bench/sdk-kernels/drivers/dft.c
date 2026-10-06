/* DftSimple benchmark app kernels (examples/gap9/dsp/benchmarks/DftSimple, dft_wrapper.c).
 * Same problem as the app: FRAME_SIZE=400 (Kconfig default); twiddles, bit-reverse table,
 * radix/span/group table and the test signal all come from the app's own gen_test_data.py
 * (gen/dft_<real|cplx>_<type>/TestData.[ch]).
 *   real (CONFIG_REAL_DFT=y, default): N_DFT=200, KerSeqDftMR_Real_* / KerParDftMR_Real_*
 *   cplx (CONFIG_REAL_DFT=n):          N_DFT=400, KerSeqDftMR_*      / KerParDftMR_*
 * Float type f32 (default) or f16 (CONFIG_FLOAT_16_DFT); f16alt is not selectable in the app
 * (DftLibraryf16a.c is in the SDK's DSP library list) and is run here as a library variant.
 * The parallel kernel runs on one core through the shim; the sequential kernel is the app's
 * fc_dft_run() / multichannel worker path. */
#include "kb.h"
#include "DspLib.h"
#include "TestData.h"
#if DT == DT_F32
#define FN(x) x##_f32
#define SUF "_f32"
#elif DT == DT_F16
#define FN(x) x##_f16
#define SUF "_f16"
#else
#define FN(x) x##_f16a
#define SUF "_f16a"
#endif
#if IS_REAL_DFT
#define SEQ FN(KerSeqDftMR_Real)
#define PAR FN(KerParDftMR_Real)
#define SEQN "DftSimple.KerSeqDftMR_Real" SUF
#define PARN "DftSimple.KerParDftMR_Real" SUF
#else
#define SEQ FN(KerSeqDftMR)
#define PAR FN(KerParDftMR)
#define SEQN "DftSimple.KerSeqDftMR" SUF
#define PARN "DftSimple.KerParDftMR" SUF
#endif
#ifndef KSEL
#define KSEL -1
#endif
static FLOAT_TYPE In[N_INPUT_FLOATS], Out[N_CPLX_OUT + 4];

#define RUN(sel, name, fun) if (KSEL < 0 || KSEL == (sel)) {                               \
        kb_acc_t acc = {0, 0, 0}; uint32_t h = 0, reps = rt_reps_v;                        \
        for (uint32_t r = 0; r <= reps; r++) {                                             \
            kb_copy(In, TestInput, sizeof In);                                             \
            KB_TIME(KB_ACC(r, acc), fun(&dft_arg));                                        \
            h = h * 31u + rt_hash(Out, N_CPLX_OUT * sizeof(FLOAT_TYPE));                   \
        }                                                                                  \
        kb_result(name, N_DFT, &acc, h);                                                   \
        kb_dump(name, N_DFT, Out, N_CPLX_OUT, sizeof(FLOAT_TYPE));                         \
    }
int main(void)
{
    DFT_Arg_T dft_arg;
    dft_arg.In = In; dft_arg.Out = Out; dft_arg.Twid = DftTwiddles;
#if IS_REAL_DFT
    dft_arg.PostTwid = DftPostTwiddles;
#else
    dft_arg.PostTwid = 0;
#endif
    dft_arg.Brev = DftBrev; dft_arg.N = rt_n(N_DFT); dft_arg.S = rt_n(N_STAGES);
    dft_arg.RadSpanGroups = DftRadSpanGroups;
    RUN(0, SEQN, SEQ);
    RUN(1, PARN, PAR);
    return 0;
}
