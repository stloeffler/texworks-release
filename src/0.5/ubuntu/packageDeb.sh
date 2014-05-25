#!/bin/sh

TOPDIR=$(pwd)
SCRIPTDIR=$(dirname "${TOPDIR}/$0")
BUILDDIR="${TOPDIR}/$1"
DISTRO="$2"
PACKAGER="$3"
DATE=$(date --rfc-2822)

cd "$BUILDDIR"

mkdir -p "debian"

for FILE in $(ls -1 "${SCRIPTDIR}/debian"); do
	if [ "$FILE" != "copyright.template" ]; then
		cp -r "${SCRIPTDIR}/debian/${FILE}" "debian/"
	fi
done


sed -e "s/<AUTHOR>/${PACKAGER}/g" -e "s/<DATE>/${DATE}/g" "${SCRIPTDIR}/debian/copyright.template" > "debian/copyright"

mv "Changelog" "debian/changelog"


if [ -f "${SCRIPTDIR}/${DISTRO}.patch" ]; then
	echo "Applying ${DISTRO}.patch"
	patch -p0 < "${SCRIPTDIR}/${DISTRO}.patch"
fi

debuild -S

