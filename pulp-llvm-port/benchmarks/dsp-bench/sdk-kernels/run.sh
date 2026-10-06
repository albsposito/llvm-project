#!/usr/bin/env bash
# Reproduces everything in this directory: input data (gen/), builds and simulations (build/),
# results.json, summary.json and report.txt. About 3 minutes on the 32-core host.
#   ./run.sh                      full run
#   ./run.sh --report-only        rebuild report.txt from results.json and analysis.txt
#   ./profile.sh <elf> [function] per-PC profile of one ELF (used for the Analysis section)
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"
exec python3 run.py "$@"
