#!/bin/bash
set -e
set -x

# Install the toolchain (and the little tweakups associated with it).
sudo ./do-cross-tc-to-ng.sh

# "bolt on" the helpers for using the final product :)
sudo cp -a container-helpers/* dchrt-ng/

# Create a .tar.xz of it
sudo tar -cJf dchrt-ng-container.tar.xz dchrt-ng
