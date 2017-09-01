#!/bin/bash
if [ $(id -u) -ne 0 ]; then
	echo "please run me with sudo" 2>&1
	exit 1
fi
if [ ! -e dchrt-ng/dev/ptmx ]; then
	echo "Make sure your working directory is proper" 2>&1
	exit 1
fi

# dchrt ships an x86_64 static qemu-arm ... the config file would work for other hosts, so adjust if you need to :P
if [ "$(uname -m)" = "x86_64" ]; then
	if [ -d  /etc/binfmt.d ]; then
		if [ ! -f /etc/binfmt.d/qemu-arm-static.conf ]; then
			cp bolt-on/qemu-arm-static.conf /etc/binfmt.d
			systemctl restart systemd-binfmt
			echo "Installed /etc/binfmt.d/qemu-arm-static.conf"
		fi
	fi
fi
rm -rf dchrt-ng/inst
cp -a inst dchrt-ng/inst
systemd-nspawn -D "$(pwd)/dchrt-ng" -M dchrt-ng-inst /inst/run.sh
