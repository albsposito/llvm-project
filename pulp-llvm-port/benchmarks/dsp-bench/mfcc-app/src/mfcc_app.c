/* MFCC front-end application benchmark (keyword-spotting feature extraction).
 *
 * One of four variants, selected with -DMFCC_FIX16 / -DMFCC_F32 / -DMFCC_F16 / -DMFCC_F16A.
 * Per frame, on the SDK clip yes.wav (16 kHz, 512-sample frame, 160-sample hop):
 *
 *   pre-emphasis -> Hann window -> real FFT (512) -> power spectrum -> mel filterbank (40)
 *   -> log (dB) -> DCT-II (13 coefficients)
 *
 * Every stage is an unmodified GAP9 SDK DSP library kernel
 * (tools/autotiler_v3/BasicKernels/DSP_Libraries), called through its parallel entry point with
 * one core (gap_ncore() == 1 in the shim), in the order the SDK's NNTool/AutoTiler MFCC
 * generator wires them. Two exceptions, both in the fixed-point variant only: this SDK release
 * has no fixed-point mel filterbank and no fixed-point log kernel (the generator still names
 * MelFilterBank_Fix32 / MFCC_ComputeLog_Fix32, but the library sources are gone), so those two
 * stages are the small glue functions below. The log glue calls the SDK's ulogn_17_15().
 *
 * Each stage is bracketed with the simulator cycle counter and the RI5CY instruction counter.
 * Hashing and printing run outside the timed regions.
 */
#include "rt.h"
#include "DspLib.h"
#include "TwiddlesDef.h"
#include "SwapTablesDef.h"
#include "RFFTTwiddlesDef.h"
#include "mfcc_tables.h"

#define NBINS (MFCC_NFFT / 2 + 1)

#if defined(MFCC_FIX16)
#define VARIANT "fix16"
typedef short int sig_t;
typedef short int out_t;
#define TW   R4_Twiddles_fix_256
#define RTW  RFFT_Twiddles_fix_512
#elif defined(MFCC_F32)
#define VARIANT "f32"
typedef float sig_t;
typedef float out_t;
#define TW   R4_Twiddles_float_256
#define RTW  RFFT_Twiddles_float_512
#define K_PREEMP PreEmphasis_f32
#define K_WIN    WindowingReal2Real_f32
#define K_RFFT   RFFT_DIF_Par_f32
#define K_SPEC   CmplxMagSquared_f32
#define K_MEL    MelFilterBank_f32
#define K_LOG    Db_f32
#define K_DCT    DctTypeII_f32
#define LOG_CLIP 1e-10f
#elif defined(MFCC_F16)
#define VARIANT "f16"
typedef f16 sig_t;
typedef f16 out_t;
#define TW   R4_Twiddles_f16_256
#define RTW  RFFT_Twiddles_f16_512
#define K_PREEMP PreEmphasis_f16
#define K_WIN    WindowingReal2Real_f16
#define K_RFFT   RFFT_DIF_Par_f16
#define K_SPEC   CmplxMagSquared_f16
#define K_MEL    MelFilterBank_f16
#ifdef MFCC_LOG_VIA_F32
#define K_LOG    Db_f16_f32
#else
#define K_LOG    Db_f16
#endif
#define K_DCT    DctTypeII_f16
#define LOG_CLIP 1e-7f          /* the SDK example's value for float16 (nntool_script.py) */
#elif defined(MFCC_F16A)
#define VARIANT "f16a"
typedef f16a sig_t;
typedef f16a out_t;
#define TW   R4_Twiddles_f16a_256
#define RTW  RFFT_Twiddles_f16a_512
#define K_PREEMP PreEmphasis_f16a
#define K_WIN    WindowingReal2Real_f16a
#define K_RFFT   RFFT_DIF_Par_f16a
#define K_SPEC   CmplxMagSquared_f16a
#define K_MEL    MelFilterBank_f16a
#ifdef MFCC_LOG_VIA_F32
#define K_LOG    Db_f16a_f32
#else
#define K_LOG    Db_f16a
#endif
#define K_DCT    DctTypeII_f16a
#define LOG_CLIP 1e-10f
#else
#error "select a variant: -DMFCC_FIX16, -DMFCC_F32, -DMFCC_F16 or -DMFCC_F16A"
#endif
#define SWAP R4_SwapTable_fix_256

enum { S_PRE, S_WIN, S_FFT, S_SPEC, S_MEL, S_LOG, S_DCT, NS };
static const char *const st_name[NS] = { "preemph", "window", "rfft", "spectrum", "mel", "log", "dct" };
static uint32_t st_c[NS], st_i[NS], st_h[NS];

#ifdef RT_HOST
static inline uint32_t tcyc(void) { return 0; }
#else
static inline uint32_t tcyc(void) { return bench_cycles32(); }
#endif

#define STAGE(s, call) do {                                        \
        uint32_t _c0 = tcyc(), _i0 = rt_instr();                   \
        call;                                                      \
        uint32_t _i1 = rt_instr(), _c1 = tcyc();                   \
        st_c[s] += _c1 - _c0; st_i[s] += _i1 - _i0;                \
    } while (0)

/* untimed: fold the stage output of this frame into the stage's running hash */
RT_UNTIMED static void st_hash(int s, const void *p, uint32_t bytes)
{
    st_h[s] = (st_h[s] ^ rt_hash(p, bytes)) * 16777619u;
}

/* ---- buffers ---- */
static sig_t In[MFCC_FRAME];
static sig_t Pre[MFCC_FRAME];
static sig_t Win[MFCC_NFFT];
static sig_t FftOut[2 * NBINS + 2];
static out_t Mfcc[MFCC_NMFCC];
static out_t MfccAll[MFCC_NFRAMES * MFCC_NMFCC];

#if defined(MFCC_FIX16)
static unsigned int Pow[NBINS];
static unsigned int Mel[MFCC_NMELS];
static signed char MelShift[MFCC_NMELS];
static short int LogMel[MFCC_NMELS];
static short int PreShift;
extern void DctTypeII_Fix16(DCT_Arg_T *Args);     /* defined in DctLibraryFix.c, not declared in DspLib.h */

/* Radix-4 fixed-point FFT wants its input in Q12 (the generator's QIn_FFT for radix 4). */
#define QIN_FFT 12
/* Power-spectrum scale: P_real = P_fix * 2^(MFCC_FIX_POW_E - 2*PreShift), with the input taken as
 * Q15 (full scale = 1.0). The constant is the fixed gain of the SDK fixed-point window + RFFT
 * chain; it was measured on the host against the float32 variant (see report). */
#ifndef MFCC_FIX_POW_E
#define MFCC_FIX_POW_E (-16)
#endif
#define LN2_Q15       22713          /* ln(2) in Q15 */
#define LN_CLIP_Q15   (-754512)      /* ln(1e-10) in Q15 */
#define DB_PER_NP_Q12 17789          /* 10/ln(10) in Q12 */

/* App glue (not an SDK kernel): sparse mel filterbank on the uint32 power spectrum.
 * Same structure as the SDK's MelFilterBank_f32: per band, a dot product of Items coefficients
 * with the power bins from Start. The power is pre-shifted per band so that the Q20 x 16-bit
 * products cannot overflow 32 bits; the shift is kept for the log stage. */
static void __attribute__((noinline)) MelFilterBank_Fix32_app(MelFilterBank_T *Arg, signed char *ShiftBuf)
{
    unsigned int *__restrict__ FramePower = (unsigned int *)Arg->FramePower;
    unsigned int *__restrict__ MelSpectr = (unsigned int *)Arg->MelSpectr;
    short int *__restrict__ Mel_Coeffs = (short int *)Arg->Mel_Coeffs;
    fbank_type_t *__restrict__ FB = (fbank_type_t *)Arg->Mel_FilterBank;
    unsigned int NB = (unsigned int)Arg->Mel_NBanks;
    for (unsigned int i = 0; i < NB; i++) {
        unsigned int Items = FB[i].Items, Start = FB[i].Start, Base = FB[i].Base;
        unsigned int Max = 0, Acc = 0;
        for (unsigned int k = 0; k < Items; k++) if (FramePower[Start + k] > Max) Max = FramePower[Start + k];
        int Shift = Max ? (int)gap_fl1(Max) - 15 : 0;
        if (Shift < 0) Shift = 0;
        for (unsigned int k = 0; k < Items; k++)
            Acc += (unsigned int)Mel_Coeffs[Base + k] * (FramePower[Start + k] >> Shift);
        MelSpectr[i] = Acc;
        ShiftBuf[i] = (signed char)Shift;
    }
}

/* App glue (not an SDK kernel): 10*log10 of the mel energies, output Q5 dB in int16.
 * ln() is the SDK's ulogn_17_15 (Q17.15 in, Q15 out); the binary exponents are added as k*ln2. */
static void __attribute__((noinline)) LogDb_Fix_app(unsigned int *__restrict__ MelSpectr, signed char *__restrict__ ShiftBuf,
                                                    short int *__restrict__ Out, unsigned int NB, int PowExp)
{
    for (unsigned int i = 0; i < NB; i++) {
        unsigned int M = MelSpectr[i];
        int L = LN_CLIP_Q15;
        if (M) {
            L = (int)ulogn_17_15(M) + (15 + ShiftBuf[i] - MFCC_MEL_Q + PowExp) * LN2_Q15;
            if (L < LN_CLIP_Q15) L = LN_CLIP_Q15;
        }
        Out[i] = (short int)(((L >> 8) * DB_PER_NP_Q12 + (1 << 13)) >> 14);
    }
}
#else
static sig_t Pow[NBINS + 1];
static sig_t Mel[MFCC_NMELS];
static sig_t LogMel[MFCC_NMELS];
#endif

/* untimed: one frame of input, as the SDK example's main.c prepares it */
RT_UNTIMED static void load_frame(uint32_t f)
{
    const short int *s = &mfcc_wav[f * MFCC_HOP];
    for (uint32_t i = 0; i < MFCC_FRAME; i++) {
#if defined(MFCC_FIX16)
        In[i] = s[i];
#else
        In[i] = ((sig_t)s[i]) / (1 << 15);
#endif
    }
}

RT_UNTIMED static void put_frame(uint32_t f)
{
    rt_puts("MFCC "); rt_u64(f);
    for (uint32_t i = 0; i < MFCC_NMFCC; i++) {
        uint32_t u = 0;
        memcpy(&u, &Mfcc[i], sizeof(out_t));
        rt_puts(" "); rt_hex(u);
        MfccAll[f * MFCC_NMFCC + i] = Mfcc[i];
    }
    rt_puts("\n");
}

/* Debug builds only (-DMFCC_DUMP_FRAME=n, never used for the timed runs): raw hex dump of every
 * stage output of frame n, on the target or the host, to localise a numerical difference. */
#ifdef MFCC_DUMP_FRAME
RT_UNTIMED static void hexdump(const char *name, const void *p, uint32_t n, uint32_t elsize)
{
    const uint8_t *b = (const uint8_t *)p;
    for (uint32_t i = 0; i < n; i++) {
        uint32_t u = 0;
        memcpy(&u, b + i * elsize, elsize);
        rt_puts("HEXD "); rt_puts(name); rt_puts(" "); rt_u64(i); rt_puts(" "); rt_hex(u); rt_puts("\n");
    }
}
#define HEXDUMP(f, name, arr, n) do { if ((f) == MFCC_DUMP_FRAME) hexdump(name, arr, n, sizeof((arr)[0])); } while (0)
#else
#define HEXDUMP(f, name, arr, n) ((void)0)
#endif

#ifdef RT_HOST
/* host only: decimal dump of every stage output of one frame, for the Python reference */
#if defined(MFCC_FIX16)
#define DUMPV(name, arr, n, T) do { for (int _k = 0; _k < (int)(n); _k++) printf("DUMP %s %d %.9g\n", name, _k, (double)((T *)(arr))[_k]); } while (0)
#else
#define DUMPV(name, arr, n, T) do { for (int _k = 0; _k < (int)(n); _k++) printf("DUMP %s %d %.9g\n", name, _k, (double)(float)((T *)(arr))[_k]); } while (0)
#endif
static int dump_frame = -1;
#else
#define DUMPV(name, arr, n, T) ((void)0)
#endif

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
#ifdef RT_HOST
    if (argc > 1) dump_frame = atoi(argv[1]);
#endif
    uint32_t nframes = rt_n(MFCC_NFRAMES);

    for (uint32_t f = 0; f < nframes; f++) {
        load_frame(f);
        /* the sample before the frame: the pre-emphasis filter state */
        short int prev = f ? mfcc_wav[f * MFCC_HOP - 1] : 0;

#if defined(MFCC_FIX16)
        PreEmphasis_T pe = { .Frame = In, .Out = Pre, .Prev = prev, .PreempFactor = MFCC_PREEMP_Q15,
                             .Shift = &PreShift, .QIn_FFT = QIN_FFT, .FrameSize = MFCC_FRAME };
        STAGE(S_PRE, PreEmphasis(&pe));
        st_hash(S_PRE, Pre, sizeof Pre);
        HEXDUMP(f, "pre", Pre, MFCC_FRAME);

        Windowing_T wn = { .Frame = Pre, .OutFrame = Win, .Window = mfcc_window,
                           .FrameSize = MFCC_NFFT, .WinSize = MFCC_FRAME, .NFrames = 1, .FrameHop = MFCC_HOP };
        STAGE(S_WIN, WindowingReal2Real_Fix16(&wn));
        st_hash(S_WIN, Win, sizeof Win);
        HEXDUMP(f, "win", Win, MFCC_NFFT);

        RFFT_Arg_T rf = { .Data = Win, .RFFT_Out = FftOut, .Twiddles = TW, .RTwiddles = RTW, .SwapTable = SWAP,
                          .N_fft = MFCC_NFFT, .NFrames = 1, .FrameStride = MFCC_HOP };
        STAGE(S_FFT, RFFT_DIF_Par_Fix16(&rf));
        st_hash(S_FFT, FftOut, 2 * NBINS * sizeof(sig_t));
        HEXDUMP(f, "fft", FftOut, 2 * NBINS);

        CmplxMag_T mg = { .FrameIn = FftOut, .FrameOut = Pow, .N = NBINS, .NFrames = 1, .ExtraQ = PreShift, .Input_QFormat = 0 };
        STAGE(S_SPEC, CmplxMagSquared_Fix16(&mg));
        st_hash(S_SPEC, Pow, NBINS * sizeof(unsigned int));
        HEXDUMP(f, "spec", Pow, NBINS);

        MelFilterBank_T ml = { .FramePower = Pow, .MelSpectr = Mel, .Mel_Coeffs = mfcc_melcoeffs,
                               .Mel_FilterBank = (short int *)mfcc_fbank, .Mel_NBanks = MFCC_NMELS };
        STAGE(S_MEL, MelFilterBank_Fix32_app(&ml, MelShift));
        st_hash(S_MEL, Mel, sizeof Mel);
        HEXDUMP(f, "mel", Mel, MFCC_NMELS);

        STAGE(S_LOG, LogDb_Fix_app(Mel, MelShift, LogMel, MFCC_NMELS, MFCC_FIX_POW_E - 2 * PreShift));
        st_hash(S_LOG, LogMel, sizeof LogMel);
        HEXDUMP(f, "log", LogMel, MFCC_NMELS);

        DCT_Arg_T dc = { .Data = LogMel, .DCTCoeff = mfcc_dct, .FeatList = Mfcc, .NInputs = MFCC_NMELS, .NDct = MFCC_NMFCC };
        STAGE(S_DCT, DctTypeII_Fix16(&dc));
        st_hash(S_DCT, Mfcc, sizeof Mfcc);
        HEXDUMP(f, "dct", Mfcc, MFCC_NMFCC);
#ifdef RT_HOST
        if ((int)f == dump_frame) {
            printf("DUMP preshift 0 %d\n", PreShift);
            DUMPV("pre", Pre, MFCC_FRAME, short); DUMPV("win", Win, MFCC_NFFT, short);
            DUMPV("fft", FftOut, 2 * NBINS, short); DUMPV("pow", Pow, NBINS, unsigned int);
            DUMPV("mel", Mel, MFCC_NMELS, unsigned int); DUMPV("melshift", MelShift, MFCC_NMELS, signed char);
            DUMPV("log", LogMel, MFCC_NMELS, short); DUMPV("mfcc", Mfcc, MFCC_NMFCC, short);
        }
#endif
#else
        PreEmphasisF_T pe = { .Frame = In, .Out = Pre, .Prev = (float)prev / (1 << 15), .PreempFactor = MFCC_PREEMP,
                              .FrameSize = MFCC_FRAME };
        STAGE(S_PRE, K_PREEMP(&pe));
        st_hash(S_PRE, Pre, sizeof Pre);
        HEXDUMP(f, "pre", Pre, MFCC_FRAME);

        Windowing_T wn = { .Frame = Pre, .OutFrame = Win, .Window = mfcc_window,
                           .FrameSize = MFCC_NFFT, .WinSize = MFCC_FRAME, .NFrames = 1, .FrameHop = MFCC_HOP };
        STAGE(S_WIN, K_WIN(&wn));
        st_hash(S_WIN, Win, sizeof Win);
        HEXDUMP(f, "win", Win, MFCC_NFFT);

        RFFT_Arg_T rf = { .Data = Win, .RFFT_Out = FftOut, .Twiddles = TW, .RTwiddles = RTW, .SwapTable = SWAP,
                          .N_fft = MFCC_NFFT, .NFrames = 1, .FrameStride = MFCC_HOP };
        STAGE(S_FFT, K_RFFT(&rf));
        st_hash(S_FFT, FftOut, 2 * NBINS * sizeof(sig_t));
        HEXDUMP(f, "fft", FftOut, 2 * NBINS);

        CmplxMag_T mg = { .FrameIn = FftOut, .FrameOut = Pow, .N = NBINS, .NFrames = 1 };
        STAGE(S_SPEC, K_SPEC(&mg));
        st_hash(S_SPEC, Pow, NBINS * sizeof(sig_t));
        HEXDUMP(f, "spec", Pow, NBINS);

        MelFilterBank_T ml = { .FramePower = Pow, .MelSpectr = Mel, .Mel_Coeffs = mfcc_melcoeffs,
                               .Mel_FilterBank = (short int *)mfcc_fbank, .Mel_NBanks = MFCC_NMELS };
        STAGE(S_MEL, K_MEL(&ml));
        st_hash(S_MEL, Mel, sizeof Mel);
        HEXDUMP(f, "mel", Mel, MFCC_NMELS);

        KerPieceWise_DSP_T lg = { .In = Mel, .Out = LogMel, .N = MFCC_NMELS, .Norm = 0,
                                  .ExtraArg0 = 0.0f, .ExtraArg1 = LOG_CLIP, .Extra = 0 };
        STAGE(S_LOG, K_LOG(&lg));
        st_hash(S_LOG, LogMel, sizeof LogMel);
        HEXDUMP(f, "log", LogMel, MFCC_NMELS);

        DCT_Arg_T dc = { .Data = LogMel, .DCTCoeff = mfcc_dct, .FeatList = Mfcc, .NInputs = MFCC_NMELS, .NDct = MFCC_NMFCC };
        STAGE(S_DCT, K_DCT(&dc));
        st_hash(S_DCT, Mfcc, sizeof Mfcc);
        HEXDUMP(f, "dct", Mfcc, MFCC_NMFCC);
#ifdef RT_HOST
        if ((int)f == dump_frame) {
            DUMPV("pre", Pre, MFCC_FRAME, sig_t); DUMPV("win", Win, MFCC_NFFT, sig_t);
            DUMPV("fft", FftOut, 2 * NBINS, sig_t); DUMPV("pow", Pow, NBINS, sig_t);
            DUMPV("mel", Mel, MFCC_NMELS, sig_t); DUMPV("log", LogMel, MFCC_NMELS, sig_t);
            DUMPV("mfcc", Mfcc, MFCC_NMFCC, sig_t);
        }
#endif
#endif
        put_frame(f);
    }

    uint32_t sum_c = 0, sum_i = 0;
    for (uint32_t s = 0; s < NS; s++) {
        rt_puts("STAGE name="); rt_puts(st_name[s]);
        rt_puts(" cycles="); rt_u64(st_c[s]);
        rt_puts(" instrs="); rt_u64(st_i[s]);
        rt_puts(" hash="); rt_hex(st_h[s]);
        rt_puts("\n");
        sum_c += st_c[s]; sum_i += st_i[s];
    }
    rt_puts("TOTAL variant=" VARIANT " frames="); rt_u64(nframes);
    rt_puts(" stage_cycles="); rt_u64(sum_c);
    rt_puts(" stage_instrs="); rt_u64(sum_i);
    rt_puts(" checksum="); rt_hex(rt_hash(MfccAll, sizeof MfccAll));
    rt_puts("\n");
    return 0;
}
