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
BUILDDIR="$1"
TARGET="$2"
POPPLERDATAFILENAME="$3"
SCRIPTDIR="${TOPDIR}/"$(dirname "$0")

POPPLER=$(basename "${POPPLERDATAFILENAME}" .tar.gz)

echo "$TOPDIR"
echo "$BUILDDIR"
echo "$TARGET"
echo "$POPPLER"

cd "${BUILDDIR}"

rm -rf package-zip
mkdir -p package-zip/share

cp "build/TeXworks.exe" package-zip/
cp COPYING package-zip/
if [ -d manual ]; then
	mkdir -p package-zip/texworks-help
	cp -r manual package-zip/texworks-help/TeXworks-manual
fi
cp -r win32/fonts package-zip/share/
tar -x -C "package-zip/share/" -f "${TOPDIR}/pkg/${POPPLERDATAFILENAME}" && mv "package-zip/share/${POPPLER}" "package-zip/share/poppler"

cp "${SCRIPTDIR}/README.package" package-zip/README.txt

cd package-zip
zip -r "${TOPDIR}/${TARGET}" *
