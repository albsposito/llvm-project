#!/usr/bin/env bash
# Build gvsoc2 gap.gap9.evk into a private prefix (SDK source read-only).
set -euo pipefail
export PYTHONDONTWRITEBYTECODE=1
SDK=/home/ubuntu/gap_sdk_release
VENV=/home/ubuntu/gvsoc-venv
W=${W:?}
G=$SDK/gvsoc2; B=$W/gvsoc2-build; P=$W/gvsoc2-install
export PATH="$VENV/bin:$PATH"
for d in gvrun config_tree; do
  cmake -S $G/$d -B $B/$d -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$P
  cmake --build $B/$d
  cmake --install $B/$d
done
rm -rf $P/generators $P/targets
MODS="$G/engine/python;$G/core/models;$G/core/targets;$G/pulp;$G/pulp/models/pulp;$G/pulp/targets;$G/gap9/models;$G/gap9/targets;$G/gvrun/python;$G/config_tree"
ENV=(env -u PYTHONPATH USE_GVRUN=1 USE_GVRUN2=1 PATH="$P/bin:$PATH")
"${ENV[@]}" cmake -S $G -B $B/main -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$P \
  -DGVSOC_MODULES="$MODS" -DGVSOC_TARGETS="gap.gap9.evk" -DBUILD_ASSERT=OFF -DCMAKE_SKIP_INSTALL_RPATH=false
"${ENV[@]}" cmake --build $B/main -j ${JOBS:-12}
cmake --install $B/main
