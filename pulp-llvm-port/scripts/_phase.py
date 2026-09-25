#!/usr/bin/env python3
# Conductor helper: replace the "Current phase:" line of PROGRESS.md.  usage: _phase.py "<text after 'Current phase: '>"
import sys, pathlib
p = pathlib.Path(__file__).resolve().parent.parent / "PROGRESS.md"
L = p.read_text().split("\n")
i = next(k for k, l in enumerate(L) if l.startswith("Current phase:"))
L[i] = "Current phase: " + sys.argv[1]
p.write_text("\n".join(L))
