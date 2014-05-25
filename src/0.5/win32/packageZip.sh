#!/bin/sh

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
