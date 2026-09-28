#!/usr/bin/env bash
# Build every app of the ladder in every variant, run what links on GVSoC2,
# and write $W/ladder.tsv (app, variant, build rc, ELF?, run rc, output hash).
#   ladder.sh [variants...]   (default: gcc clang clang-compat-nowerror-gnuas-gnuld
#                              clang-compat-nowerror-sdkp)
W=${SDK_CLANG_WORK:-/tmp/sdk-clang-work}
HERE=$(cd "$(dirname "$0")" && pwd)
APPS=${APPS:-"examples/gap9/basic/helloworld examples/gap9/basic/perf examples/gap9/basic/malloc
examples/gap9/basic/os/kernel/multi_threads examples/gap9/basic/gvsoc/pcer
examples/gap9/dsp/benchmarks/Fir examples/gap9/dsp/benchmarks/MatMul examples/gap9/dsp/benchmarks/FFTL1
examples/gap9/dsp/benchmarks/DftSimple examples/gap9/dsp/autotiler/MatAdd examples/gap9/dsp/autotiler/MatMul
examples/gap9/dsp/autotiler/DotProd examples/gap9/nn/autotiler/MnistGraph"}
VARS=${*:-"gcc clang clang-compat-nowerror-gnuas-gnuld clang-compat-nowerror-sdkp"}
PAR=${PAR:-6}
jobs_list=()
for a in $APPS; do for v in $VARS; do jobs_list+=("$a $v"); done; done
printf '%s\n' "${jobs_list[@]}" | xargs -P "$PAR" -L 1 bash -c '
  a=$0; v=$1; W='"$W"'; HERE='"$HERE"'
  B=$W/bld/$(echo "$a" | tr / _)__$v
  JOBS=4 timeout 1800 "$HERE/build_app.sh" "$a" "$v" > /dev/null 2>&1; brc=$?
  elf=$(cd "$B" 2>/dev/null && for f in $(find . -maxdepth 1 -type f -perm -u+x); do
          head -c4 "$f" | grep -q ELF && echo "$B/${f#./}"; done | head -1)
  rrc=-; h=-
  if [ -n "$elf" ]; then
    SDK_CLANG_WORK=$W "$HERE/run_app.sh" "$elf" ${RUN_TIMEOUT:-600} > "$B/run.out" 2>&1; rrc=$?
    h=$(grep -v "^\[run_app\]" "$B/run.out" | md5sum | cut -c1-8)
  fi
  echo -e "$a\t$v\t$brc\t${elf:+yes}\t$rrc\t$h" >> "$W/ladder.tsv"
'
sort "$W/ladder.tsv" | column -t -s $'\t'
