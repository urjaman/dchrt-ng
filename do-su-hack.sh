#!/bin/sh
set -e
set -x

if [ ! -e dchrt-ng/usr/ngcc-x64/bin ]; then
	echo "This hack expects to be implemented on top of the cross compiler as native inside container thing"
	exit 1
fi

./install-su-hack.sh
[ -f dchrt-ng/usr/bin/sudo ] && sudo mv dchrt-ng/usr/bin/sudo dchrt-ng/usr/bin/sudo.real
