#!/bin/bash
set -e

arch="arm64ec"
arch_host="aarch64-linux-android28"
install_dir="$HOME/wine-install-aarch64"
OUTPUT_DIR="$HOME/compiled-files-aarch64"

# Use absolute path for NDK compiler
NDK_ROOT="$HOME/Android/Sdk/ndk/27.3.13750724"
NDK_BIN="$NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin"
CC="$NDK_BIN/aarch64-linux-android28-clang"
CXX="$NDK_BIN/aarch64-linux-android28-clang++"

export CROSSCC="aarch64-w64-mingw32-gcc"
export CROSSCXX="aarch64-w64-mingw32-g++"
export WINE_TOOLS="$GITHUB_WORKSPACE/wine-tools"

export PATH="$NDK_BIN:$HOME/toolchains/llvm-mingw-20250920-ucrt-ubuntu-22.04-x86_64/bin:$PATH"

# CLEAN ENVIRONMENT: Remove all Termux pollution
unset DEPS_DIR
unset PKG_CONFIG_LIBDIR
unset ACLOCAL_PATH
unset C_INCLUDE_PATH
unset CPLUS_INCLUDE_PATH

# Use only NDK sysroot and host headers
export CFLAGS="-O3 -march=armv8-a+crypto+fp16 -fomit-frame-pointer --sysroot=$NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
export CPPFLAGS="-I/usr/include -I/usr/include/x86_64-linux-gnu"
export LDFLAGS=""

for arg in "$@"
do
  if [ "$arg" == "--build-sysvshm" ]
  then
    echo "Building sysvshm..."
    cd $GITHUB_WORKSPACE/android/android_sysvshm
    bash build-aarch64.sh
    # Save it to a clean location
    mkdir -p $HOME/compiled_libs
    cp build-aarch64/libandroid-sysvshm.so $HOME/compiled_libs/libsysvshm.so
    cd $GITHUB_WORKSPACE
  fi

  if [ "$arg" == "--configure" ]
  then
    echo "Configuring..."

    ./configure \
      --host=$arch_host \
      --target=$arch_host \
      --with-wine-tools=$WINE_TOOLS \
      --prefix=$install_dir \
      --without-x \
      --without-freetype \
      --disable-tests \
      --without-vulkan \
      --without-pulse \
      --without-alsa \
      --without-udev \
      --without-sdl \
      --without-gstreamer \
      --without-oss \
      --enable-archs=$arch \
      CROSSCC="$CROSSCC" \
      CROSSCXX="$CROSSCXX" \
      CC="$CC" \
      CXX="$CXX" \
      CFLAGS="$CFLAGS" \
      LDFLAGS="$LDFLAGS" \
      CPPFLAGS="$CPPFLAGS"

    PATCHES=(
      "common/dlls_ntdll_unix_esync_c.patch"
      "common/dlls_ntdll_unix_fsync_c.patch"
      "common/server_esync_c.patch"
      "common/server_fsync_c.patch"
      "test-bylaws/include_winternl_h.patch"
      "test-bylaws/dlls_ntdll_ntdll_misc_h.patch"
      "test-bylaws/dlls_ntdll_unwind_h.patch"
      "arm64ec/dlls_ntdll_unix_virtual_c.patch"
      "common/loader_preloader_c.patch"
      "x86_64/dlls_ntdll_unix_signal_x86_64_c.patch"
      "common/dlls_ntdll_unix_server_c.patch"
      "arm64ec/dlls_ntdll_loader_c.patch"
      "arm64ec/dlls_ntdll_unix_loader_c.patch"
      "arm64ec/dlls_wow64_syscall_c.patch"
      "arm64ec/loader_wine_inf_in.patch"
      "arm64ec/programs_wineboot_wineboot_c.patch"
    )

    for patch in "${PATCHES[@]}"; do
      git apply ./android/patches/$patch || echo "Falha ao aplicar patch $patch, ignorando..."
    done
  fi

  if [ "$arg" == "--build" ]
  then
    echo "Building..."
    # Fix for widl cannot find stdole2.tlb
    mkdir -p dlls/atl
    ln -sf ../stdole2.tlb/stdole2.tlb dlls/atl/stdole2.tlb || true
    rm -rf $OUTPUT_DIR/bin
    rm -rf $OUTPUT_DIR/lib
    rm -rf $OUTPUT_DIR/share
    rm -rf $install_dir
    make -j$(nproc)
  fi

  if [ "$arg" == "--install" ]
  then
    echo "Installing..."
    mkdir -p $OUTPUT_DIR/bin
    mkdir -p $OUTPUT_DIR/lib
    mkdir -p $OUTPUT_DIR/share
    mkdir -p $install_dir
    make install -j$(nproc)
    cp -r $install_dir/bin/wine* $OUTPUT_DIR/bin || true
    cp -r $install_dir/bin/reg* $OUTPUT_DIR/bin || true
    cp -r $install_dir/bin/msi* $OUTPUT_DIR/bin || true
    cp -r $install_dir/bin/notepad $OUTPUT_DIR/bin || true
    cp -r $install_dir/lib/wine  $OUTPUT_DIR/lib || true
    cp -r $install_dir/share/wine  $OUTPUT_DIR/share || true
    # Include libsysvshm.so from our clean location
    cp $HOME/compiled_libs/libsysvshm.so $OUTPUT_DIR/lib/ || true
  fi
done
