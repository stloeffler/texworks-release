#!/bin/sh

# This is part of the texworks-release scripts
# Copyright (C) 2013-2015  Stefan Löffler
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

