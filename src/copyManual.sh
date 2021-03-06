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

MANUALDIR="$1"
DESTDIR="$2"

rm -rf "$DESTDIR/manual"
cp -r "$MANUALDIR/html/TeXworks-manual" "$DESTDIR/manual"
cp -r "$MANUALDIR/pdf"/* "$DESTDIR/manual"
