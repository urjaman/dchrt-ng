#!/bin/bash
set -e
set -x

BBV=busybox-1.27.1
if [ ! -f busybox/busybox ]; then
 if [ ! -f $BBV.tar.bz2 ]; then
  wget https://busybox.net/downloads/$BBV.tar.bz2
 fi
 rm -rf $BBV
 tar xf $BBV.tar.bz2
 mv $BBV busybox
 cd busybox
 cp ../busybox-only-su.config .config
 make oldconfig
 make -j6
 cd ..
fi
