#!/bin/sh
set -e
set -x

if [ ! -e dchrt-ng/usr/ngcc-x64/bin ]; then
	echo "This hack expects to be implemented on top of the cross compiler as native inside container thing"
	exit 1
fi
BBV=busybox-1.27.1

if [ ! -f $BBV/busybox ]; then
 if [ ! -f $BBV.tar.bz2 ]; then
  wget https://busybox.net/downloads/$BBV.tar.bz2
 fi
 tar xf $BBV.tar.bz2
 cd $BBV
 cp ../busybox-only-su.config .config
 make oldconfig
 make -j6
 cd ..
fi

sudo cp $BBV/busybox dchrt-ng/usr/ngcc-x64/bin/su
sudo chown 0:0 dchrt-ng/usr/ngcc-x64/bin/su
sudo chmod +s dchrt-ng/usr/ngcc-x64/bin/su
[ -f dchrt-ng/usr/bin/sudo ] && sudo mv dchrt-ng/usr/bin/sudo dchrt-ng/usr/bin/sudo.real
