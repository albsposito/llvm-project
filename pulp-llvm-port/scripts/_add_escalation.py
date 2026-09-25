#!/usr/bin/env python3
# Conductor helper: append rows to the Escalations table of PROGRESS.md.
# usage: _add_escalation.py "<row>" ["<row>" ...]   (each row a full "| ... |" line)
import sys, pathlib
p = pathlib.Path(__file__).resolve().parent.parent / "PROGRESS.md"
L = p.read_text().split("\n")
h = next(k for k, l in enumerate(L) if l.startswith("| Step | Task | Question"))
end = h + 2
while end < len(L) and L[end].startswith("|"):
    end += 1
L[end:end] = sys.argv[1:]
p.write_text("\n".join(L))
