#!/bin/sh

# This is part of the texworks-release scripts
# Copyright (C) 2015-2015  Stefan Löffler
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
BUILDDIR="$1"
TARGET="$2"
POPPLERDATAFILENAME="$3"
COMPILER="$4"
SCRIPTDIR="${TOPDIR}/"$(dirname "$0")

POPPLER=$(basename "${POPPLERDATAFILENAME}" .tar.gz)

cd "${BUILDDIR}"

rm -rf release
mkdir -p release/share

cp "build/TeXworks.exe" release/
cp "${MXE_DIR}/usr/i686-w64-mingw32/lib/lua52.dll" release/
cp COPYING release/
if [ -d manual ]; then
	mkdir -p release/texworks-help
	cp -r manual release/texworks-help/TeXworks-manual
fi
cp -r win32/fonts release/share/

tar -x -C "release/share/" -f "${TOPDIR}/pkg/${POPPLERDATAFILENAME}" && mv "release/share/${POPPLER}" "release/share/poppler"
cp "${SCRIPTDIR}/README.package" release/README.txt

wine "$COMPILER" "win32/texworks-setup-script.iss"
for FILE in win32/Output/TeXworks-setup-v*.exe; do
	echo "$FILE > ${TOPDIR}/${TARGET}"
	mv "$FILE" "${TOPDIR}/${TARGET}"
done

