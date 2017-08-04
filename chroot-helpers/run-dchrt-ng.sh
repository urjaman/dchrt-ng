#!/bin/bash

#Hi, maybe add a cd command in front here if you'd like to use this from elsewhere, e.g.
# cd /media/ext4-sdcard/

name=dchrt-ng

if [ $(id -u) -ne 0 ]; then
	echo "please run me with sudo or as root with your username as the parameter" 2>&1
	exit 1
fi

if [ ! -f $name.sqfs ]; then
	echo "Run me from the directory with $name.sqfs"
	exit 1
fi
mkdir -p $name{,-ro,-rw}
[ ! -d $name-ro/dev ] && mount -t squashfs -o loop $name.sqfs $name-ro
[ ! -d $name/dev ] && mount -t aufs -o dirs=$name-rw=rw:$name-ro=rr none $name

cd $name

./chroot-dropbear.sh "$@"
cd ..
# Try to unmount things
umount $name
umount $name-ro
