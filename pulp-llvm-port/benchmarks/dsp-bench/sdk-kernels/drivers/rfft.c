/* RFFTL1 and IRFFTL1 benchmark app kernels
 * (examples/gap9/dsp/benchmarks/RFFTL1/FFTRunTest.c + FFTMultiFrameTest.c, IRFFTL1/FFTRunTest.c).
 *   default        RFFTL1: real FFT sizes MINDIM=128 .. MAXDIM=4096, forward transform timed
 *                  (RFFT_DIF_Seq_*, and RFFT_DIF_Par_* on one core). NFRAMES=1 (default), so the
 *                  app's ParSeq path is not run.
 *   -DAPP_IRFFT    IRFFTL1: sizes 128 .. 2048; forward transform (untimed here, it is the RFFTL1
 *                  kernel) then the inverse, timed (IRFFT_DIF_Seq_*, IRFFT_DIF_Par_*).
 * Input = each app's own In_Data.h from its InitData.c (gen/rfftl1, gen/irfftl1); f16 input is
 * (f16) of the f32 input as in RunFFT(). Tables installed with RFFT_InstallTwiddlesAndSwapLUT. */
#define GAP_ALL_FFT_TABLES
#define GAP_ALL_SWAP_TABLES
#define GAP_ALL_RFFT_TABLES
#include "kb.h"
#include "DspLib.h"
#include "TwiddlesDef.h"
#include "RFFTTwiddlesDef.h"
#include "SwapTablesDef.h"
#include "In_Data.h"
#define MINDIM 128
#ifdef APP_IRFFT
#define MAXDIM 2048
#define APP "IRFFTL1."
#else
#define MAXDIM 4096
#define APP "RFFTL1."
#endif
#if DT == DT_F32
typedef float T;
#define TW(r, n) r##_Twiddles_float_##n
#define RTW(n) RFFT_Twiddles_float_##n
#define FN(x) x##_f32
#define SUF "_f32"
#elif DT == DT_F16
typedef f16 T;
#define TW(r, n) r##_Twiddles_f16_##n
#define RTW(n) RFFT_Twiddles_f16_##n
#define FN(x) x##_f16
#define SUF "_f16"
#elif DT == DT_F16A
typedef f16a T;
#define TW(r, n) r##_Twiddles_f16a_##n
#define RTW(n) RFFT_Twiddles_f16a_##n
#define FN(x) x##_f16a
#define SUF "_f16a"
#else
typedef short T;
#define TW(r, n) r##_Twiddles_fix_##n
#define RTW(n) RFFT_Twiddles_fix_##n
#define FN(x) x##_Fix16
#define SUF "_Fix16"
#endif
#ifndef KSEL
#define KSEL -1
#endif

static T In[MAXDIM], InBuff[MAXDIM], OutBuff[2 * (MAXDIM + 1)];
static float L1_Twiddles[MAXDIM], L1_RTwiddles[MAXDIM];
static short L1_SwapLUT[MAXDIM];

RT_UNTIMED static void prep(uint32_t n)
{
#if DT == DT_FIX16
    for (uint32_t i = 0; i < n; i++) In[i] = InDataQ16[i];
#elif DT == DT_F16A
    for (uint32_t i = 0; i < n; i++) KB_SET_BF16(In[i], InDataf32[i]);
#else
    for (uint32_t i = 0; i < n; i++) In[i] = (T) InDataf32[i];
#endif
}

static void one(int Nfft)
{
    FFT_InstallArg_T ArgIns;
    uint32_t inb = (uint32_t)Nfft * sizeof(T), outb = (uint32_t)(Nfft + 2) * sizeof(T), reps = rt_reps_v;
    ArgIns.Nfft = Nfft;
    ArgIns.Radix = ((Nfft >> 1) == 256 || (Nfft >> 1) == 1024) ? 4 : 2;
    ArgIns.L1_Twiddles = L1_Twiddles; ArgIns.L1_RTwiddles = L1_RTwiddles; ArgIns.L1_SwapLUT = L1_SwapLUT;
    switch (Nfft >> 1) {
        case 64:   ArgIns.Twiddles = TW(R2, 64);   ArgIns.SwapLUT = R2_SwapTable_fix_64;   ArgIns.RTwiddles = RTW(128);  break;
        case 128:  ArgIns.Twiddles = TW(R2, 128);  ArgIns.SwapLUT = R2_SwapTable_fix_128;  ArgIns.RTwiddles = RTW(256);  break;
        case 256:  ArgIns.Twiddles = TW(R4, 256);  ArgIns.SwapLUT = R4_SwapTable_fix_256;  ArgIns.RTwiddles = RTW(512);  break;
        case 512:  ArgIns.Twiddles = TW(R2, 512);  ArgIns.SwapLUT = R2_SwapTable_fix_512;  ArgIns.RTwiddles = RTW(1024); break;
        case 1024: ArgIns.Twiddles = TW(R4, 1024); ArgIns.SwapLUT = R4_SwapTable_fix_1024; ArgIns.RTwiddles = RTW(2048); break;
        default:   ArgIns.Twiddles = TW(R2, 2048); ArgIns.SwapLUT = R2_SwapTable_fix_2048; ArgIns.RTwiddles = RTW(4096); break;
    }
    RFFT_InstallTwiddlesAndSwapLUT(&ArgIns, DT == DT_F32);

    if (KSEL < 0 || KSEL == 0) {            /* sequential */
        kb_acc_t a = {0, 0, 0}; uint32_t h = 0;
        for (uint32_t r = 0; r <= reps; r++) {
            kb_copy(InBuff, In, inb);
#ifdef APP_IRFFT
            FN(RFFT_DIF_Seq)(InBuff, OutBuff, (T *) L1_Twiddles, (T *) L1_RTwiddles, L1_SwapLUT, Nfft);
            KB_TIME(KB_ACC(r, a), FN(IRFFT_DIF_Seq)(OutBuff, InBuff, (T *) L1_Twiddles, (T *) L1_RTwiddles, L1_SwapLUT, Nfft));
            h = h * 31u + rt_hash(InBuff, inb);
#else
            KB_TIME(KB_ACC(r, a), FN(RFFT_DIF_Seq)(InBuff, OutBuff, (T *) L1_Twiddles, (T *) L1_RTwiddles, L1_SwapLUT, Nfft));
            h = h * 31u + rt_hash(OutBuff, outb);
#endif
        }
#ifdef APP_IRFFT
        kb_result(APP "IRFFT_DIF_Seq" SUF, Nfft, &a, h);
        if (DT_IS_FLOAT) kb_dump(APP "IRFFT_DIF_Seq" SUF, Nfft, InBuff, Nfft, sizeof(T));
#else
        kb_result(APP "RFFT_DIF_Seq" SUF, Nfft, &a, h);
        if (DT_IS_FLOAT) kb_dump(APP "RFFT_DIF_Seq" SUF, Nfft, OutBuff, Nfft + 2, sizeof(T));
#endif
    }
    if (KSEL < 0 || KSEL == 1) {            /* parallel entry point, one core */
        kb_acc_t a = {0, 0, 0}; uint32_t h = 0;
        RFFT_Arg_T FFTArg;
        for (uint32_t r = 0; r <= reps; r++) {
            kb_copy(InBuff, In, inb);
            FFTArg.Data = InBuff; FFTArg.RFFT_Out = OutBuff;
            FFTArg.Twiddles = L1_Twiddles; FFTArg.RTwiddles = L1_RTwiddles; FFTArg.SwapTable = L1_SwapLUT;
            FFTArg.N_fft = Nfft; FFTArg.NFrames = 1; FFTArg.FrameStride = Nfft;
#ifdef APP_IRFFT
            FN(RFFT_DIF_Par)(&FFTArg);
            FFTArg.Data = OutBuff; FFTArg.RFFT_Out = InBuff;
            KB_TIME(KB_ACC(r, a), FN(IRFFT_DIF_Par)(&FFTArg));
            h = h * 31u + rt_hash(InBuff, inb);
#else
            KB_TIME(KB_ACC(r, a), FN(RFFT_DIF_Par)(&FFTArg));
            h = h * 31u + rt_hash(OutBuff, outb);
#endif
        }
#ifdef APP_IRFFT
        kb_result(APP "IRFFT_DIF_Par" SUF, Nfft, &a, h);
        if (DT_IS_FLOAT) kb_dump(APP "IRFFT_DIF_Par" SUF, Nfft, InBuff, Nfft, sizeof(T));
#else
        kb_result(APP "RFFT_DIF_Par" SUF, Nfft, &a, h);
        if (DT_IS_FLOAT) kb_dump(APP "RFFT_DIF_Par" SUF, Nfft, OutBuff, Nfft + 2, sizeof(T));
#endif
    }
}

int main(void)
{
    prep(rt_n(MAXDIM));
    for (int FFTBins = rt_n(MINDIM); FFTBins <= MAXDIM; FFTBins *= 2) one(FFTBins);
    return 0;
}
