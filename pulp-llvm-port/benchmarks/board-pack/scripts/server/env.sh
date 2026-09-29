# Server-side only (how the prebuilt ELFs and sim-results were produced on the build host).
# Source after benchmarks/sdk-clang/setup.sh has created $SDK_CLANG_WORK (SDK mirror, venv,
# GVSoC2 gap.gap9.evk, clang snapshot). The SDK itself is never written.
: "${SDK_CLANG_WORK:?set SDK_CLANG_WORK to the sdk-clang work dir}"
W=$SDK_CLANG_WORK
export GAP_RISCV_GCC_TOOLCHAIN=${GAP_RISCV_GCC_TOOLCHAIN:-/home/ubuntu/gap_riscv_toolchain_ubuntu}
source /home/ubuntu/gap_sdk_release/configs/gap9_evk_audio.sh >/dev/null 2>&1
export GAP_SDK_HOME=$W/sdk GVSOC2_INSTALL_DIR=$W/gvsoc2-install PYTHONDONTWRITEBYTECODE=1
export PATH=$W/venv/bin:$GAP_RISCV_GCC_TOOLCHAIN/bin:$PATH
export PACK_CMAKE_ARGS="-DPython_EXECUTABLE=$W/venv/bin/python -DSFU=/bin/true"
