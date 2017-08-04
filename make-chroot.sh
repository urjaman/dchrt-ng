#!/bin/bash
set -e
set -x

# This set of steps creates the chroot stuff ;)

./make-dchrt-ng.sh

# "bolt on" the helper for using the final product :)
sudo cp -a chroot-helpers/chroot-dropbear.sh dchrt-ng/

mkdir -p dchrt-ng-chroot
# squash it, exclude the qemu-arm-static from sqfs as useless waste of space on the pandora
rm -rf dchrt-ng-chroot/dchrt-ng.sqfs
sudo mksquashfs dchrt-ng dchrt-ng-chroot/dchrt-ng.sqfs -e usr/bin/qemu-arm-static -comp xz -b 1M
sudo chown $(whoami) dchrt-ng-chroot/dchrt-ng.sqfs
cp chroot-helpers/run-dchrt-ng.sh dchrt-ng-chroot/
