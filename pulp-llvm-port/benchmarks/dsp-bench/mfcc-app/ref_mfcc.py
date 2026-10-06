#!/usr/bin/env python3
"""Float64 numpy reference MFCC for the benchmark, written from librosa's definitions.

librosa itself is not installed on this host, so this is a numpy re-implementation of
  librosa.feature.mfcc(y, sr=16000, n_mfcc=13, n_fft=512, hop_length=160, win_length=512,
                       window='hann', center=False, power=2, n_mels=40, dct_type=2, norm='ortho')
with two deliberate differences, both matching what the SDK kernels compute:
  * a 0.97 pre-emphasis filter in front (librosa.effects.preemphasis, zi = previous sample);
  * power_to_db without the top_db=80 clamp (the SDK Db kernels only clip at amin = 1e-10).
It is independent of gen_tables.py (separate code for the window, mel weights and DCT).

  ref_mfcc.py            -> prints the reference as JSON (frames x 13)
Needs numpy: run it with /home/ubuntu/gvsoc-venv/bin/python.
"""
import json, struct, sys, wave
import numpy as np

WAV = '/home/ubuntu/gap_sdk_release/examples/gap9/dsp/samples/yes.wav'
SR, FRAME, HOP, NFFT, NMELS, NMFCC, PREEMP, AMIN = 16000, 512, 160, 512, 40, 13, 0.97, 1e-10


def hz_to_mel(f):
    f = np.asarray(f, dtype=float)
    mel = f / (200.0 / 3)
    logstep = np.log(6.4) / 27.0
    return np.where(f >= 1000.0, 15.0 + np.log(np.maximum(f, 1e-9) / 1000.0) / logstep, mel)


def mel_to_hz(m):
    m = np.asarray(m, dtype=float)
    logstep = np.log(6.4) / 27.0
    return np.where(m >= 15.0, 1000.0 * np.exp(logstep * (m - 15.0)), m * 200.0 / 3)


def mel_matrix():
    fftfreqs = np.fft.rfftfreq(NFFT, 1.0 / SR)
    mel_f = mel_to_hz(np.linspace(hz_to_mel(0.0), hz_to_mel(SR / 2), NMELS + 2))
    fdiff = np.diff(mel_f)
    ramps = mel_f[:, None] - fftfreqs[None, :]
    lower = -ramps[:-2] / fdiff[:-1, None]
    upper = ramps[2:] / fdiff[1:, None]
    W = np.maximum(0, np.minimum(lower, upper))
    return W * (2.0 / (mel_f[2:] - mel_f[:-2]))[:, None]


def dct_matrix():
    n = np.arange(NMELS)
    D = np.cos(np.pi / NMELS * (n[None, :] + 0.5) * np.arange(NMFCC)[:, None]) * np.sqrt(2.0 / NMELS)
    D[0] *= np.sqrt(0.5)
    return D


def stages():
    """Returns dict of per-stage arrays, each (frames, n)."""
    w = wave.open(WAV)
    n = w.getnframes()
    x = np.array(struct.unpack(f'<{n}h', w.readframes(n)), dtype=float) / 32768.0
    nframes = (n - FRAME) // HOP
    win = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(FRAME) / FRAME)
    W, D = mel_matrix(), dct_matrix()
    out = {k: [] for k in ('pre', 'win', 'pow', 'mel', 'log', 'mfcc')}
    for f in range(nframes):
        fr = x[f * HOP:f * HOP + FRAME]
        prev = x[f * HOP - 1] if f else 0.0
        pre = fr - PREEMP * np.concatenate(([prev], fr[:-1]))
        xw = pre * win
        P = np.abs(np.fft.rfft(xw, NFFT)) ** 2
        mel = W @ P
        lg = 10.0 * np.log10(np.maximum(mel, AMIN))
        for k, v in (('pre', pre), ('win', xw), ('pow', P), ('mel', mel), ('log', lg), ('mfcc', D @ lg)):
            out[k].append(v)
    return {k: np.array(v) for k, v in out.items()}


if __name__ == '__main__':
    json.dump(stages()['mfcc'].tolist(), sys.stdout)
