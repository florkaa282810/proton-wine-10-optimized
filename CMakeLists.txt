
# ============================================
# PROTON-FEX BRIDGE OPTIMIZATIONS
# ============================================

# Shared Memory Buffer (256MB)
add_definitions(-DFEX_SHARED_BUFFER_SIZE=268435456)
add_definitions(-DFEX_BATCH_SIZE=64)

# Batch Translation (reduce context switches)
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DENABLE_BATCH_TRANSLATION=1")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DENABLE_BATCH_TRANSLATION=1")

# Lock-free Communication
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DENABLE_LOCKFREE=1")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DENABLE_LOCKFREE=1")

# GTA San Andreas Compatibility
add_definitions(-DENABLE_GTA_SAN_COMPAT=1)
add_definitions(-DFORCE_VULKAN=1)
add_definitions(-DBYPASS_DRM_CHECK=1)
add_definitions(-DGTA_INIT_TIMEOUT=60000)
add_definitions(-DENABLE_SSE42=1)
add_definitions(-DENABLE_AVX=1)

# Aggressive Optimization Flags for Bridge
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -march=armv8-a+crc+simd -O3 -fno-semantic-interposition")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -march=armv8-a+crc+simd -O3 -fno-semantic-interposition")

# Reduce syscall overhead
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DENABLE_FAST_SYSCALLS=1")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DENABLE_FAST_SYSCALLS=1")

message(STATUS "✓ Proton-FEX Bridge Optimizations Enabled")

# ============================================
# FEX-CORE ↔ PROTON ARM64EC COMMUNICATION OPTIMIZATION
# ============================================

# Zero-Copy Memory Mapping
add_definitions(-DENABLE_ZERO_COPY_MMAP=1)
add_definitions(-DFEX_MMAP_SIZE=536870912)  # 512MB
add_definitions(-DFEX_RING_BUFFER_ENTRIES=16384)

# Lock-Free Queue for Instruction Dispatch
add_definitions(-DENABLE_LOCKFREE_QUEUE=1)
add_definitions(-DLOCKFREE_QUEUE_SIZE=65536)

# Reduce Syscall Overhead
add_definitions(-DENABLE_SYSCALL_BATCHING=1)
add_definitions(-DFEX_SYSCALL_BATCH_SIZE=32)

# Intelligent Prefetching
add_definitions(-DENABLE_PREFETCH=1)
add_definitions(-DPREFETCH_DISTANCE=256)

# Aggressive Compiler Flags for Bridge Communication
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} \
    -march=armv8-a+crc+simd \
    -mtune=cortex-a76 \
    -O3 \
    -fno-semantic-interposition \
    -fno-plt \
    -fomit-frame-pointer \
    -finline-limit=500000 \
    -funroll-loops \
    -fprefetch-loop-arrays \
    -fvectorize \
    -fslp-vectorize-aggressive")

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} \
    -march=armv8-a+crc+simd \
    -mtune=cortex-a76 \
    -O3 \
    -fno-semantic-interposition \
    -fno-plt \
    -fomit-frame-pointer \
    -finline-limit=500000 \
    -funroll-loops \
    -fprefetch-loop-arrays \
    -fvectorize \
    -fslp-vectorize-aggressive")

# Linker Optimization
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} \
    -Wl,-O3 \
    -Wl,--as-needed \
    -Wl,--gc-sections")

message(STATUS "✓ FEX-Core ↔ Proton ARM64EC Communication Optimizations ENABLED")
