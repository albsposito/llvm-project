#!/usr/bin/env bash
# Conductor helper: land several approved branches in order, each against the latest landed errors file.
#   scripts/_land_chain.sh <step> <errors-before.json> <id>...   (prints one verdict line per id)
cd "$(dirname "$0")/.." ; step=$1; before=$2; shift 2
for id in "$@"; do
  scripts/_land.sh $step $id "$before" --allow-unmasked > logs/land-$step-$id.log 2>&1
  v=$(python3 -c "import json;r=json.load(open('tasks/$step/$id.integrate.json'));print(r['verdict'],r.get('reason',''),'fixed=',r.get('errors_fixed'),'unmasked=',r.get('errors_unmasked'),'onchanged=',r.get('errors_on_changed_lines'))")
  echo "$id: $v"
  case "$v" in LANDED*) before=tasks/$step/work_${step}_$id.build.clusters.json;; esac
done
echo "LATEST_ERRORS=$before"
