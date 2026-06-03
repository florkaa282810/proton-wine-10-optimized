#!/bin/bash
set -e

# Berserker Original Flags - A fórmula que funcionou
export CFLAGS="-Ofast -ffast-math -funsafe-math-optimizations -fno-trapping-math -fno-math-errno -falign-functions=64 -falign-loops=64 -finline-functions -finline-limit=10000 -march=armv8-a+crc+crypto -mcpu=generic"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-Wl,-O1 -Wl,--as-needed -Wl,--sort-common -Wl,--hash-style=gnu"

# Aplicar apenas os patches de performance comprovada
patch -p1 < android/patches/arm64ec/berserker_optimizations.patch
patch -p1 < android/patches/arm64ec/squeeze_pack_optimizations.patch
patch -p1 < android/patches/arm64ec/io_optimization_open_world.patch
patch -p1 < android/patches/arm64ec/thread_cpu_affinity.patch
patch -p1 < android/patches/arm64ec/gpu_pipeline_optimization.patch

echo "Build Berserker Original configurado com sucesso."
