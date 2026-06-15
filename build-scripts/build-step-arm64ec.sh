#!/bin/bash
set -e

arch="arm64ec"
arch_host="aarch64-linux-android28"
install_dir="$HOME/wine-install-aarch64"
OUTPUT_DIR="$HOME/compiled-files-aarch64"

# Use absolute path for NDK compiler to ensure configure can find it
NDK_ROOT="$HOME/Android/Sdk/ndk/27.3.13750724"
NDK_BIN="$NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin"
CC="$NDK_BIN/aarch64-linux-android28-clang"
CXX="$NDK_BIN/aarch64-linux-android28-clang++"

export CROSSCC="aarch64-w64-mingw32-gcc"
export CROSSCXX="aarch64-w64-mingw32-g++"
export WINE_TOOLS="$GITHUB_WORKSPACE/wine-tools"

export PATH="$NDK_BIN:$HOME/toolchains/llvm-mingw-20250920-ucrt-ubuntu-22.04-x86_64/bin:$PATH"

# Android/Termux environment paths
export DEPS_DIR="$HOME/termuxfs/aarch64/usr"
export PKG_CONFIG_LIBDIR="$DEPS_DIR/lib/pkgconfig:$DEPS_DIR/share/pkgconfig"
export ACLOCAL_PATH="$DEPS_DIR/lib/aclocal:$DEPS_DIR/share/aclocal"
export CFLAGS="-O3 -march=armv8-a+crypto+fp16 -fomit-frame-pointer --sysroot=$NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
    export CPPFLAGS="-I$DEPS_DIR/include -I$DEPS_DIR/include/SDL2 -I$DEPS_DIR/include/gstreamer-1.0 -I$DEPS_DIR/include/glib-2.0 -I$DEPS_DIR/lib/glib-2.0/include"
    export LDFLAGS="-L$DEPS_DIR/lib -L$DEPS_DIR/lib/pulseaudio -Wl,-rpath-link,$DEPS_DIR/lib"
    export SDL2_CFLAGS="-I$DEPS_DIR/include/SDL2"
    export SDL2_LIBS="-L$DEPS_DIR/lib -lSDL2"

for arg in "$@"
do
  if [ "$arg" == "--build-sysvshm" ]
  then
    echo "Building sysvshm..."
    cd $GITHUB_WORKSPACE/android/android_sysvshm
    bash build-aarch64.sh
    mkdir -p $HOME/termuxfs/aarch64/usr/lib
    cp build-aarch64/libandroid-sysvshm.so $HOME/termuxfs/aarch64/usr/lib/libsysvshm.so
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
      --with-vulkan \
      --with-sdl \
      --without-gstreamer \
      --without-oss \
      --disable-tests \
      --enable-archs=$arch \
      CROSSCC="$CROSSCC" \
      CROSSCXX="$CROSSCXX" \
      CC="$CC" \
      CXX="$CXX" \
      CFLAGS="$CFLAGS" \
      LDFLAGS="$LDFLAGS" \
      CPPFLAGS="$CPPFLAGS"

    PATCHES=(
      # input patches
      "dlls_winebus_sys_bus_sdl_c.patch"

      # shm_utils
      "dlls_ntdll_unix_esync_c.patch"
      "dlls_ntdll_unix_fsync_c.patch"
      "server_esync_c.patch"
      "server_fsync_c.patch"

      # winex11
      "dlls_winex11_drv_x11drv_h.patch"
      "dlls_winex11_drv_bitblt_c.patch"
      "dlls_winex11_drv_desktop_c.patch"
      "dlls_winex11_drv_mouse_c.patch"
      "dlls_winex11_drv_window_c.patch"
      "dlls_winex11_drv_x11drv_main_c.patch"

      # address space patches
      "dlls_ntdll_unix_virtual_c.patch"
      "loader_preloader_c.patch"

      # syscall Patches
      "dlls_ntdll_unix_signal_x86_64_c.patch"

      # pulse Patches
      "dlls_winepulse_drv_pulse_c.patch"

      # desktop patches
      "programs_explorer_desktop_c.patch"

      # path patches
      "dlls_ntdll_unix_server_c.patch"

      # winlator patches
      "dlls_amd_ags_x64_unixlib_c.patch"
      "dlls_winex11_drv_opengl_c.patch"

      # advapi32 patches
      "dlls_advapi32_advapi_c.patch"

      # browser patches
      "programs_winebrowser_makefile_in.patch"
      "programs_winebrowser_main_c.patch"

      # clipboard patches
      "dlls_user32_makefile_in.patch"
      "dlls_user32_clipboard_c.patch"
      "dlls_win32u_clipboard_c.patch"

      # fexcore patch
      "dlls_ntdll_loader_c.patch"
      "dlls_ntdll_unix_loader_c.patch"
      "dlls_wow64_syscall_c.patch"
      "loader_wine_inf_in.patch"

      "programs_wineboot_wineboot_c.patch"
      "dlls_wdscore_wdscore_spec.patch"
    )

    for patch in "${PATCHES[@]}"; do
      git apply ./android/patches/$patch || echo "Falha ao aplicar patch $patch, ignorando..."
    done
  fi

  if [ "$arg" == "--build" ]
  then
    echo "Building..."
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
  fi
done
