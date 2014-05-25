#!/bin/sh

MANUALDIR="$1"
DESTDIR="$2"

rm -rf "$DESTDIR/manual"
cp -r "$MANUALDIR/html/TeXworks-manual" "$DESTDIR/manual"
