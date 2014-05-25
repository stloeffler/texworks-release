#!/bin/sh

TOPDIR=$(pwd)
BUILDDIR=$1

cd "${BUILDDIR}"
mkdir build && cd build
cmake .. \
	-DCMAKE_BUILD_TYPE="Release" \
	-DTW_BUILD_ID='official' \
	-DDESIRED_QT_VERSION=4 \
	-DCMAKE_TOOLCHAIN_FILE="${MXE_DIR}/usr/i686-w64-mingw32/share/cmake/mxe-conf.cmake" \
	-DCMAKE_PREFIX_PATH="${MXE_DIR}/usr/i686-w64-mingw32/qt5/lib/cmake" \
	-DTEXWORKS_ADDITIONAL_LIBS="imm32;opengl32;lcms;jpeg;tiff;png;lzma;freetype;bz2;pcre16;sicuuc;sicudt;wsock32;winmm"

make && "${MXE_DIR}/usr/bin/i686-w64-mingw32-strip" *.exe
