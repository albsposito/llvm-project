#!/usr/bin/env bash
# Conductor helper: land one approved build-fix branch with integrate.py.
#   scripts/_land.sh <step> <task-id> <errors-before.json> [extra integrate args]
set -uo pipefail
cd "$(dirname "$0")/.." && source config.env
step=$1; id=$2; before=$3; shift 3
python3 scripts/integrate.py --int-wt wt/int-$step --branch work/$step/$id --stack-base "$(cat steps/$step/base_tag)" \
  --notes-root notes --build-cmd "scripts/build.sh wt/int-$step build/int-$step $JOBS_INTEGRATION" \
  --errors-before "$before" --out tasks/$step/$id.integrate.json "$@"
