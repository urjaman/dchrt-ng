#!/bin/bash
set -e
set -x

[ ! -f busybox/busybox ] && ./build-su-hack.sh

TGT="$1"
[ -z "$TGT" ] && TGT="dchrt-ng"

sudo cp busybox/busybox $TGT/usr/ngcc-x64/bin/su
sudo chown 0:0 $TGT/usr/ngcc-x64/bin/su
sudo chmod +s $TGT/usr/ngcc-x64/bin/su

