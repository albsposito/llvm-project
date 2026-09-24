# Build container for the PULP LLVM port.
# The host (Amazon Linux 2) has gcc 7.3.1, below LLVM's minimum host compiler,
# and no ninja/ccache/clang/lld, so every LLVM build and lit run happens in here.
# Worktrees, build dirs and the ccache are bind-mounted at their host paths
# (see scripts/in-builder.sh), so paths in logs match paths on the host.
FROM public.ecr.aws/docker/library/ubuntu:24.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential cmake ninja-build ccache python3 git \
      clang lld ca-certificates zlib1g-dev libzstd-dev \
 && rm -rf /var/lib/apt/lists/*

ENV CCACHE_COMPILERCHECK=content \
    CCACHE_NOHASHDIR=true \
    CCACHE_MAXSIZE=80G
