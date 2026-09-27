#!/usr/bin/env bash
# Conductor helper: land one approved test-phase branch through integrate.py's build + lit gates.
#   scripts/_land_lit.sh <step> <id> <errors-before.json> <lit-before.json> <baseline-lit.json> [renames.json] [upstream-tag]
set -uo pipefail
cd "$(dirname "$0")/.." && source config.env
step=$1; id=$2; eb=$3; lb=$4; base=$5; ren=${6:-}; tag=${7:-}
out=steps/$step/lit-land
lit="scripts/lit.sh wt/int-$step build/int-$step $JOBS_INTEGRATION $out $base $ren $tag; rc=\$?; cp $out/lit_diff.json {diff_out} || exit 2; exit \$rc"
python3 scripts/integrate.py --int-wt wt/int-$step --branch work/$step/$id --stack-base "$(cat steps/$step/base_tag)" \
  --notes-root notes --build-cmd "scripts/build.sh wt/int-$step build/int-$step $JOBS_INTEGRATION" \
  --errors-before "$eb" --lit-cmd "$lit" --lit-before "$lb" --out tasks/$step/$id.integrate.json --allow-unmasked
