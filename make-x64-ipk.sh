#!/bin/bash
set -e
set -x

[ ! -f busybox/busybox ] && ./build-su-hack.sh

TGT=ngcc-ipk

./install-cross-tc.sh $TGT
cp -v busybox/busybox $TGT/usr/ngcc-x64/bin/su
chmod +s $TGT/usr/ngcc-x64/bin/su

REV=1

make_ipk_control() {
	echo "Package: toolchain-x64"
	echo "Version: 1.0-r$REV"
	echo "Description: Container x86-64 to arm cross toolchain binaries"
	echo "Section: extras"
	echo "Priority: optional"
	echo "Maintainer: dchrt-ng"
	echo "License: none"
	echo "Architecture: armv7"
}

mkdir -p ipk-tmp
make_ipk_control > ipk-tmp/control
(cd ipk-tmp; tar -czf control.tar.gz control; rm control)
echo "2.0" > ipk-tmp/debian-binary
(cd $TGT; tar --group=root --owner=root -czf ../ipk-tmp/data.tar.gz *)
(cd ipk-tmp; ar -crf ../toolchain-x64-1.0-r$REV.ipk debian-binary data.tar.gz control.tar.gz)
rm -rf ipk-tmp
