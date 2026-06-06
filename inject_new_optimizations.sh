#!/bin/bash

# Otimizações NOVAS (que provavelmente não estão lá)
NEW_OPTS="-flto=thin -fvectorize -fslp-vectorize -fslp-vectorize-aggressive -fprefetch-loop-arrays -floop-unroll-and-jam -falign-functions=64 -falign-loops=64 -finline-limit=200000"

# Encontrar todos os CMakeLists.txt
for cmake_file in $(find . -name "CMakeLists.txt" -type f); do
  # Verificar se já tem as flags
  if ! grep -q "flto=thin\|fvectorize" "$cmake_file"; then
    echo "Injetando em: $cmake_file"
    cat << 'PATCH' >> "$cmake_file"

# ============================================
# PROTON QUANTUM OVERDRIVE - NEW OPTIMIZATIONS
# ============================================
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -flto=thin -fvectorize -fslp-vectorize -fslp-vectorize-aggressive -fprefetch-loop-arrays -floop-unroll-and-jam -falign-functions=64 -falign-loops=64 -finline-limit=200000")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -flto=thin -fvectorize -fslp-vectorize -fslp-vectorize-aggressive -fprefetch-loop-arrays -floop-unroll-and-jam -falign-functions=64 -falign-loops=64 -finline-limit=200000")
PATCH
  fi
done

echo "✓ Otimizações novas injetadas sem conflitos!"
