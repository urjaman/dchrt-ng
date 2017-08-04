#!/bin/bash
set -e
set -x

if [ ! -f pandora-xfce-image-omap3-pandora.tar.bz2 ]; then
	wget https://www.openpandora.org/firmware/images/pandora-xfce-image-omap3-pandora.tar.bz2
fi

if [ ! -d dchrt-ng ]; then
	mkdir dchrt-ng
	sudo tar --numeric-owner -xvf pandora-xfce-image-omap3-pandora.tar.bz2 -C dchrt-ng
fi

# get a static qemu
if [ ! -f dchrt-ng/usr/bin/qemu-arm-static ]; then
	[ ! -f qemu-user-static.deb ] && wget http://ftp.debian.org/debian/pool/main/q/qemu/qemu-user-static_2.8+dfsg-6_amd64.deb -O qemu-user-static.deb
	ar p qemu-user-static.deb data.tar.xz | tar xJf - ./usr/bin/qemu-arm-static
	sudo mv usr/bin/qemu-arm-static dchrt-ng/usr/bin
	rm -rf usr
fi

# run the in-container dev stuff installation process
sudo ./nspawn-install.sh

