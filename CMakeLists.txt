
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
