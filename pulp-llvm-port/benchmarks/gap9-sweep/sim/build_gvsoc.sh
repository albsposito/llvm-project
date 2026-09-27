#!/usr/bin/env bash
# Rebuild GVSoC2 with only the bare-metal ri5ky_testbench target.
# Same commands as `make gvsoc2.all GVSOC2_TARGETS=ri5ky_testbench` in the GAP SDK
# Makefile, but run from a virtualenv and with -j$JOBS instead of the hard-coded -j 6.
set -euo pipefail
SDK=${SDK:-/home/ubuntu/gap_sdk_release}
VENV=${VENV:-/home/ubuntu/gvsoc-venv}
JOBS=${JOBS:-24}
TARGETS=${TARGETS:-ri5ky_testbench}
G=$SDK/gvsoc2; B=$SDK/build/gvsoc2; P=$SDK/install/gvsoc2
export PATH="$VENV/bin:$PATH"
[ -x "$VENV/bin/python" ] || python3 -m venv "$VENV"
pip install -q -r $G/gvrun/requirements.txt -r $G/config_tree/requirements.txt -r $G/core/requirements.txt
for d in gvrun config_tree; do
  cmake -S $G/$d -B $B/$d -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$P
  cmake --build $B/$d
  cmake --install $B/$d
done
rm -rf $P/generators $P/targets
MODS="$G/engine/python;$G/core/models;$G/core/targets;$G/pulp;$G/pulp/models/pulp;$G/pulp/targets;$G/gap9/models;$G/gap9/targets;$G/gvrun/python;$G/config_tree"
ENV=(env -u PYTHONPATH USE_GVRUN=1 USE_GVRUN2=1 PATH="$P/bin:$PATH")
"${ENV[@]}" cmake -S $G -B $B/main -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$P \
  -DGVSOC_MODULES="$MODS" -DGVSOC_TARGETS="$TARGETS" -DBUILD_ASSERT=OFF -DCMAKE_SKIP_INSTALL_RPATH=false
"${ENV[@]}" cmake --build $B/main -j $JOBS
cmake --install $B/main
