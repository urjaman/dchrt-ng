#!/bin/bash
set -e
set -x
# This is the things to remove for a fresh-ish build (but no new source downloads)
rm -rf ngcc-x64 ngcc-ipk tcsrc/{bb,gb} toolchain-x64-1.0-r*.ipk

