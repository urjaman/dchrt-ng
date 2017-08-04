#!/bin/bash
set -e
set -x

# This set of steps provides the full container experience ;)

./make-dchrt-ng.sh
./make-cross-tc.sh
sudo ./install-cross-tc-to-ng.sh
./do-su-hack.sh

# "bolt on" the helpers for using the final product :)
sudo cp -a container-helpers/* dchrt-ng/

