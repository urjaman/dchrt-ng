#!/bin/bash
set -e
set -x
# This is the things to remove for a fresh-ish build (but no new source downloads)
rm -vrf ngcc-x64 tcsrc/{bb,gb}

