#!/bin/bash
set -e
set -x

# Make sure we have the toolchain ipk
. x64-ipk-name
if [ ! -f $X64_IPK ]; then
	./make-cross-tc.sh
	./make-x64-ipk.sh
fi

sudo ./do-cross-tc-to-ng.sh

# "bolt on" the helpers for using the final product :)
sudo cp -a container-helpers/* dchrt-ng/

# Create a .tar.xz of it
sudo tar -cJf dchrt-ng-container.tar.xz dchrt-ng
