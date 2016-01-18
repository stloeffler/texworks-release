#!/bin/sh

# This is part of the texworks-release scripts
# Copyright (C) 2013-2014  Stefan Löffler
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# For links to further information, or to contact the authors,
# see <https://github.com/stloeffler/texworks-release>.

TOPDIR=$(pwd)
BUILDDIR=$1

cd "${BUILDDIR}"

# We need to run getGitRevInfo.sh manually (as CMake would try to run getGitRevInfo.bat)
./getGitRevInfo.sh

mkdir build && cd build
cmake .. \
	-DCMAKE_BUILD_TYPE="Release" \
	-DTW_BUILD_ID='official' \
	-DDESIRED_QT_VERSION=5 \
	-DCMAKE_TOOLCHAIN_FILE="${MXE_DIR}/usr/${MXE_TARGET}/share/cmake/mxe-conf.cmake" \
	-DCMAKE_PREFIX_PATH="${MXE_DIR}/usr/${MXE_TARGET}/qt5/lib/cmake" \
	-DTEXWORKS_ADDITIONAL_LIBS="imm32;opengl32;lcms;jpeg;tiff;png;lzma;freetype;harfbuzz;glib-2.0;intl;iconv;ws2_32;bz2;pcre16;sicuuc;sicudt;wsock32;winmm"

make && "${MXE_DIR}/usr/bin/${MXE_TARGET}-strip" *.exe
