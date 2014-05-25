#!/bin/sh

MANUALDIR="$1"

cd "${MANUALDIR}"

make && make dist
