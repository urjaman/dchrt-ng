#!/bin/bash
set -x
set -e
cd /inst

# Firstly, run the opkg post-install stuff
if [ -e /etc/rcS.d/S40configure ]; then
	opkg-cl configure
	rm -f /etc/rcS.d/S40configure
fi

./sz-upgrade.sh

# Delete files used only in the installation
rm -rf /inst
