#!/usr/bin/env python3
"""Table generator for the MFCC application benchmark (pure Python, no numpy needed).

Writes gen/mfcc_tables.h with:
  - the wav samples of the SDK clip yes.wav as an int16 C array,
  - the Hann window, the sparse mel filterbank and the DCT-II table,
    each in four number formats: Q-format int16, float32, IEEE float16 and bfloat16
    (the two 16-bit float formats are written as raw bit patterns, so that no
    float -> float16 conversion has to run on the target).

The formulas follow the SDK's own LUT generator
(tools/autotiler_v3/Generators/DSP_Generators/SetupLUT.py) and librosa:
  window  : periodic Hann (scipy.signal.get_window('hann', N, fftbins=True))
  mel     : librosa.filters.mel(sr, n_fft, n_mels, fmin=0, fmax=sr/2, htk=False, norm='slaney'),
            stored sparse as (Start, Items, Base) per band, as SetupLUT.SparseMelFilterBanksCode does
  DCT     : SetupLUT.SetupDCTTable(n_mels, dct_type=2, norm='ortho'), first N_MFCC rows

The FFT twiddles, the RFFT twiddles and the bit-reverse swap table are NOT generated here:
the benchmark compiles the SDK's own LUT_Tables/*.c for them.
"""
import math, pathlib, struct, sys, wave

HERE = pathlib.Path(__file__).resolve().parent
WAV = pathlib.Path('/home/ubuntu/gap_sdk_release/examples/gap9/dsp/samples/yes.wav')

SR, FRAME, HOP, NFFT, NMELS, NMFCC = 16000, 512, 160, 512, 40, 13
MEL_Q = 20          # fixed-point mel coefficients are Q20 in int16 (largest slaney weight is 0.0136)
WIN_Q = 15          # FP2FIX(w, 15) = w * 32767, as SetupLUT.py
DCT_Q = 14          # DctTypeII_Fix16 normalises by 14 bits
PREEMP = 0.97


def f32(x):
    return struct.unpack('<f', struct.pack('<f', x))[0]


def f16_bits(x):
    return struct.unpack('<H', struct.pack('<e', x))[0]


def bf16_bits(x):
    """float32 -> bfloat16, round to nearest even (bfloat16 = upper 16 bits of float32)."""
    u = struct.unpack('<I', struct.pack('<f', x))[0]
    lsb = (u >> 16) & 1
    u += 0x7fff + lsb
    return (u >> 16) & 0xffff


def hz_to_mel(f):
    f_sp = 200.0 / 3
    min_log_hz, logstep = 1000.0, math.log(6.4) / 27.0
    if f >= min_log_hz:
        return min_log_hz / f_sp + math.log(f / min_log_hz) / logstep
    return f / f_sp


def mel_to_hz(m):
    f_sp = 200.0 / 3
    min_log_hz, logstep = 1000.0, math.log(6.4) / 27.0
    min_log_mel = min_log_hz / f_sp
    if m >= min_log_mel:
        return min_log_hz * math.exp(logstep * (m - min_log_mel))
    return f_sp * m


def mel_filters():
    nb = NFFT // 2 + 1
    fft_f = [k * SR / NFFT for k in range(nb)]
    m0, m1 = hz_to_mel(0.0), hz_to_mel(SR / 2)
    mel_f = [mel_to_hz(m0 + (m1 - m0) * i / (NMELS + 1)) for i in range(NMELS + 2)]
    W = []
    for i in range(NMELS):
        lo, ce, hi = mel_f[i], mel_f[i + 1], mel_f[i + 2]
        enorm = 2.0 / (hi - lo)
        row = [max(0.0, min((f - lo) / (ce - lo), (hi - f) / (hi - ce))) * enorm for f in fft_f]
        W.append(row)
    return W


def sparse(W):
    """(Start, Items, Base) triplets + flat coefficient list, as SetupLUT.SparseMelFilterBanksCode."""
    fb, coeffs, base = [], [], 0
    for row in W:
        nz = [k for k, v in enumerate(row) if v != 0]
        if not nz:
            fb.append((0, 0, base)); continue
        start, items = nz[0], nz[-1] - nz[0] + 1
        fb.append((start, items, base))
        coeffs += row[start:start + items]
        base += items
    return fb, coeffs


def dct_table():
    T = []
    for k in range(NMFCC):
        s = math.sqrt(1.0 / NMELS) if k == 0 else math.sqrt(2.0 / NMELS)
        T += [s * math.cos(math.pi / NMELS * (i + 0.5) * k) for i in range(NMELS)]
    return T


def emit(out, ctype, name, vals, fmt, per=8):
    out.append(f'static {ctype} {name}[{len(vals)}] = {{')
    for i in range(0, len(vals), per):
        out.append('\t' + ' '.join(fmt(v) + ',' for v in vals[i:i + per]))
    out.append('};')


def emit_formats(out, name, vals, q):
    """One table in the format the selected variant needs."""
    out.append('#if defined(MFCC_FIX16)')
    scale = (1 << q) - 1 if q == WIN_Q else (1 << q)
    emit(out, 'short int', name, [int(round(v * scale)) for v in vals], lambda v: f'{v:6d}')
    out.append('#elif defined(MFCC_F32)')
    emit(out, 'float', name, vals, lambda v: f'{float(f"{f32(v):.9g}")!r}f', per=6)
    out.append('#elif defined(MFCC_F16)')
    emit(out, 'unsigned short', name, [f16_bits(v) for v in vals], lambda v: f'0x{v:04x}')
    out.append('#elif defined(MFCC_F16A)')
    emit(out, 'unsigned short', name, [bf16_bits(v) for v in vals], lambda v: f'0x{v:04x}')
    out.append('#endif')


def main():
    w = wave.open(str(WAV))
    assert (w.getnchannels(), w.getsampwidth(), w.getframerate()) == (1, 2, SR), w.getparams()
    n = w.getnframes()
    samples = list(struct.unpack(f'<{n}h', w.readframes(n)))
    nframes = (n - FRAME) // HOP        # same formula as the SDK example's main.c

    window = [0.5 - 0.5 * math.cos(2 * math.pi * i / FRAME) for i in range(FRAME)]
    W = mel_filters()
    fb, coeffs = sparse(W)
    dct = dct_table()

    out = ['/* Generated by gen_tables.py -- do not edit. See that file for the formulas. */',
           '#pragma once',
           f'#define MFCC_SR {SR}', f'#define MFCC_FRAME {FRAME}', f'#define MFCC_HOP {HOP}',
           f'#define MFCC_NFFT {NFFT}', f'#define MFCC_NMELS {NMELS}', f'#define MFCC_NMFCC {NMFCC}',
           f'#define MFCC_NFRAMES {nframes}', f'#define MFCC_NSAMPLES {n}',
           f'#define MFCC_MEL_Q {MEL_Q}', f'#define MFCC_DCT_Q {DCT_Q}',
           f'#define MFCC_NCOEFFS {len(coeffs)}',
           f'#define MFCC_PREEMP {PREEMP}f',
           f'#define MFCC_PREEMP_Q15 {int(PREEMP * 32767)}',
           '']
    emit(out, 'const short int', 'mfcc_wav', samples, lambda v: f'{v:6d}', per=12)
    # sparse filterbank description: 3 unsigned shorts per band (fbank_type_t)
    emit(out, 'unsigned short', 'mfcc_fbank', [x for t in fb for x in t], lambda v: f'{v:4d}', per=3)
    emit_formats(out, 'mfcc_window', window, WIN_Q)
    emit_formats(out, 'mfcc_melcoeffs', coeffs, MEL_Q)
    emit_formats(out, 'mfcc_dct', dct, DCT_Q)
    (HERE / 'gen').mkdir(exist_ok=True)
    (HERE / 'gen/mfcc_tables.h').write_text('\n'.join(out) + '\n')
    print(f'wrote gen/mfcc_tables.h: {n} samples, {nframes} frames, {len(coeffs)} mel coefficients, '
          f'max mel weight {max(coeffs):.5f}, bands {fb[0]}..{fb[-1]}')


if __name__ == '__main__':
    sys.exit(main())
