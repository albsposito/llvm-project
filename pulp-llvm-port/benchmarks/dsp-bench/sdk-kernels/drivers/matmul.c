/* MatMul benchmark app kernels (examples/gap9/dsp/benchmarks/MatMul/MatMulRunTest.c).
 * The app is f32 only. It runs
 *   - MatMulSimpleSeq(): the app's own plain-C reference loop (copied verbatim below),
 *   - KerParMatMulDSP_f32 on 64x64 * 64x64 ("small matrices, no autotiler"), 8 cores,
 *   - the autotiler-generated MatMul_fp32, which tiles the Kconfig-default
 *     128x256 * 256x128 product into KerParMatMulDSP_f32 calls.
 * Here: both sizes, KerParMatMulDSP_f32 called directly on the whole matrices on one core
 * (no autotiler tiling, no DMA), and MatMulSimpleSeq. Matrices as init_matrices() in the app:
 * M1[h][w] = 1/(h+2), M2[h][w] = 1/(w+4).
 * -DDT=0/2/3: library variants the app does not call (KerParMatMulDSP_Fix16 / _f16 / _f16a),
 * 64x64x64 only. Fix16 input: the same matrices in Q12 (FP2FIX), Norm=12. */
#include "kb.h"
#include "DspLib.h"
#include "at_api.h"
#ifndef FP2FIX
#define FP2FIX(Val, Precision) ((int)((Val)*((1 << (Precision))-1)))
#endif
#if DT == DT_F32
typedef float T;
#define KER KerParMatMulDSP_f32
#define KERN "MatMul.KerParMatMulDSP_f32"
#define BIG 1
#elif DT == DT_F16
typedef f16 T;
#define KER KerParMatMulDSP_f16
#define KERN "MatMul.KerParMatMulDSP_f16"
#define BIG 0
#elif DT == DT_F16A
typedef f16a T;
#define KER KerParMatMulDSP_f16a
#define KERN "MatMul.KerParMatMulDSP_f16a"
#define BIG 0
#else
typedef short T;
#define KER KerParMatMulDSP_Fix16
#define KERN "MatMul.KerParMatMulDSP_Fix16"
#define BIG 0
#endif
#ifndef KSEL
#define KSEL -1
#endif
#if BIG
#define MAXH1 128
#define MAXW1 256
#define MAXW2 128
#else
#define MAXH1 64
#define MAXW1 64
#define MAXW2 64
#endif
static T M1[MAXH1 * MAXW1], M2[MAXW1 * MAXW2], Out[MAXH1 * MAXW2], OutGT[MAXH1 * MAXW2], BufferColIn2[4 * MAXW1];

#if DT == DT_F32
#define gap_fc_readhwtimer() 0
/* ---- verbatim from MatMulRunTest.c ---- */
static void init_matrices(float *M1, float *M2, int H1, int W1, int H2, int W2) {
    // Initialize Matrixes
    for (int h=0; h<H1; h++) {
        for (int w=0; w<W1; w++) {
            M1[h*W1 + w] = 1.0 / (float) (h + 2);
        }
    }
    for (int h=0; h<H2; h++) {
        for (int w=0; w<W2; w++) {
            M2[h*W2 + w] = 1.0 / (float) (w + 4);
        }
    }
}

static int MatMulSimpleSeq(float *M1, float *M2, float *Out, int H1, int W1, int W2, int Transposed) {

    int start = gap_fc_readhwtimer();
    /* Simple sequential in L2 */
    if (Transposed) {
        for (int h=0; h<H1; h++) {
            for (int w2=0; w2<W2; w2++) {
                float Acc = 0.0;
                for (int w=0; w<W1; w++) {
                    Acc += M1[h*W1 + w] * M2[w2*W1 + w];
                }
                Out[h*W2 + w2] = Acc;
            }
        }
    } else {
        for (int h=0; h<H1; h++) {
            for (int w2=0; w2<W2; w2++) {
                float Acc = 0.0;
                for (int w=0; w<W1; w++) {
                    Acc += M1[h*W1 + w] * M2[w*W2 + w2];
                }
                Out[h*W2 + w2] = Acc;
            }
        }
    }
    int elapsed = gap_fc_readhwtimer() - start;
    return elapsed;
}
/* ---- end verbatim ---- */
/* the app's function is static (inlined into main there); keep one out-of-line copy so that it
 * has a symbol for the size table and the per-PC profile */
__attribute__((noinline)) int MatMulSimpleSeq_app(float *A, float *B, float *O, int H1, int W1, int W2)
{ return MatMulSimpleSeq(A, B, O, H1, W1, W2, 0); }
#else
RT_UNTIMED static void init_matrices(T *A, T *B, int H1, int W1, int H2, int W2)
{
    for (int h = 0; h < H1; h++) for (int w = 0; w < W1; w++) {
        float v = 1.0f / (float)(h + 2);
#if DT == DT_FIX16
        A[h * W1 + w] = (T) FP2FIX(v, 12);
#elif DT == DT_F16A
        KB_SET_BF16(A[h * W1 + w], v);
#else
        A[h * W1 + w] = (T) v;
#endif
    }
    for (int h = 0; h < H2; h++) for (int w = 0; w < W2; w++) {
        float v = 1.0f / (float)(w + 4);
#if DT == DT_FIX16
        B[h * W2 + w] = (T) FP2FIX(v, 12);
#elif DT == DT_F16A
        KB_SET_BF16(B[h * W2 + w], v);
#else
        B[h * W2 + w] = (T) v;
#endif
    }
}
#endif

static void one(int H1, int W1, int W2, uint32_t tag, uint32_t reps)
{
    uint32_t outb = (uint32_t)(H1 * W2) * sizeof(T);
    init_matrices(M1, M2, H1, W1, W1, W2);
#if DT == DT_F32
    if (KSEL < 0 || KSEL == 0) {
        kb_acc_t a = {0, 0, 0}; uint32_t h = 0;
        for (uint32_t r = 0; r <= reps; r++) {
            KB_TIME(KB_ACC(r, a), MatMulSimpleSeq_app(M1, M2, OutGT, H1, W1, W2));
            h = h * 31u + rt_hash(OutGT, outb);
        }
        kb_result("MatMul.MatMulSimpleSeq_app_f32", tag, &a, h);
        kb_dump("MatMul.MatMulSimpleSeq_app_f32", tag, OutGT, H1 * W2, sizeof(T));
    }
#endif
    if (KSEL < 0 || KSEL == 1) {
        kb_acc_t a = {0, 0, 0}; uint32_t h = 0;
        MatMul_DSP_T MatMulArgs = {
            .In1 = M1, .In2 = M2, .Out = Out, .BufferColIn2 = BufferColIn2,
            .W_In1 = W1, .H_In1 = H1, .W_In2 = W2, .W_Out = W2,
            .OutFirstCol = 0, .ColFirst = 0, .Norm = (DT == DT_FIX16) ? 12 : 0
        };
        for (uint32_t r = 0; r <= reps; r++) {
            KB_TIME(KB_ACC(r, a), KER(&MatMulArgs));
            h = h * 31u + rt_hash(Out, outb);
        }
        kb_result(KERN, tag, &a, h);
        if (DT_IS_FLOAT) kb_dump(KERN, tag, Out, H1 * W2, sizeof(T));
    }
}

int main(void)
{
    one(rt_n(64), rt_n(64), rt_n(64), 64, rt_reps_v);            /* the app's "small matrices" case */
#if BIG
    one(rt_n(128), rt_n(256), rt_n(128), 128, 2);                /* Kconfig default H_M1 x W_M1 x W_M2 */
#endif
    return 0;
}
