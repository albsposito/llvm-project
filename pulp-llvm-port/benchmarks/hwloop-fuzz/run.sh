#!/bin/bash
# run.sh first last [jobs] : run one.sh over a seed range in parallel (same environment
# variables as one.sh), print the status lines sorted by seed, then a summary to stderr.
first=${1:?usage: run.sh first last [jobs]}; last=${2:?}; jobs=${3:-8}
H=$(cd "$(dirname "$0")" && pwd)
out=$(seq $first $last | xargs -P $jobs -I{} bash $H/one.sh {} | sort -n)
echo "$out"
{ echo "== seeds $first-$last REF=${REF:-host}: $(echo "$out" | grep -c .) lines"
  echo "   MISMATCH (clang != reference): $(echo "$out" | grep -c MISMATCH) seeds: $(echo "$out" | grep MISMATCH | awk '{print $1}' | tr '\n' ' ')"
  echo "   REFDISAGREE (host gcc -O0 != GAP9 GCC -mnohwloop): $(echo "$out" | grep -c REFDISAGREE) seeds: $(echo "$out" | grep REFDISAGREE | awk '{print $1}' | tr '\n' ' ')"
  echo "   NEWFAIL/OBJFAIL (clang crash): $(echo "$out" | grep -cE 'NEWFAIL|OBJFAIL')   REFFAIL/GCCFAIL/XCHECKFAIL: $(echo "$out" | grep -cE 'REFFAIL|GCCFAIL|XCHECKFAIL')"
} >&2
