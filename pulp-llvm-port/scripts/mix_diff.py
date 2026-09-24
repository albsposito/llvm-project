#!/usr/bin/env python3
"""Instruction-mix diff between reference and candidate binaries (downstream oracle, check 5).

  mix_diff.py REF.dis CAND.dis [--tolerance 0.10] [--out r.json]

Inputs are `llvm-objdump -d` text. Mnemonics are counted per PULP family. A family that
is present in the reference and absent in the candidate is a hard FAIL (an optimisation
died: e.g. hardware loops no longer inferred, SIMD scalarised). A family whose count moves
by more than the tolerance in either direction is a FLAG for review; an unexplained
improvement is as suspicious as a regression. Exit 1 on any FAIL, 0 otherwise.
"""
import argparse
import json
import re
import sys
from collections import Counter
from pathlib import Path

FAMILIES = {
    "hwloop": re.compile(r"^(lp\.|cv\.(setup|starti|endi|count|counti)\b)"),
    "post-increment": re.compile(r"^(p\.(lb|lbu|lh|lhu|lw|sb|sh|sw)\b|cv\.(lb|lbu|lh|lhu|lw|sb|sh|sw)\b)"),
    "packed-simd": re.compile(r"^(pv\.|cv\.(add|sub|avg|min|max|srl|sra|sll|or|xor|and|abs|dot|sdot|shuffle|pack|extract|insert|cmp)[a-z]*\.)"),
    "mac": re.compile(r"^(p\.mac|p\.msu|cv\.mac|cv\.msu)"),
    "bitmanip-pulp": re.compile(r"^(p\.(extract|insert|bclr|bset|cnt|ff1|fl1|clb|ror|abs|min|max|clip|exths|exthz|extbs|extbz))"),
    "frep": re.compile(r"^frep\."),
    "ssr": re.compile(r"^(scfg|ssr)"),
    "dma": re.compile(r"^dm"),
}
LINE = re.compile(r"^\s*[0-9a-f]+:\s+(?:[0-9a-f]{2,8}\s+)+(?P<mnem>[a-z][\w.]*)")


def count(path):
    fam, mnems = Counter(), Counter()
    for line in Path(path).read_text(errors="replace").splitlines():
        m = LINE.match(line)
        if not m:
            continue
        mn = m.group("mnem")
        mnems[mn] += 1
        for name, rx in FAMILIES.items():
            if rx.match(mn):
                fam[name] += 1
                break
    return fam, mnems


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("ref")
    ap.add_argument("cand")
    ap.add_argument("--tolerance", type=float, default=0.10)
    ap.add_argument("--out")
    args = ap.parse_args()
    rf, rm = count(args.ref)
    cf, cm = count(args.cand)
    rows = []
    for name in FAMILIES:
        r, c = rf[name], cf[name]
        if r == 0 and c == 0:
            continue
        if r > 0 and c == 0:
            verdict = "FAIL"
        elif r == 0:
            verdict = "FLAG"
        else:
            verdict = "FLAG" if abs(c - r) / r > args.tolerance else "OK"
        rows.append({"family": name, "ref": r, "cand": c, "verdict": verdict})
    report = {"families": rows, "total_ref": sum(rm.values()), "total_cand": sum(cm.values()),
              "fail": any(r["verdict"] == "FAIL" for r in rows)}
    text = json.dumps(report, indent=2)
    if args.out:
        Path(args.out).write_text(text)
    print(text)
    return 1 if report["fail"] else 0


if __name__ == "__main__":
    sys.exit(main())
