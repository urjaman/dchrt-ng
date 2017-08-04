#!/bin/bash

#Hi, maybe add a cd command in front here if you'd like to use this from elsewhere, e.g.
# cd /media/ext4-sdcard/

$name=dchrt-ng

if [ $(id -u) -ne 0 ]; then
	echo "please run me with sudo or as root with your username as the parameter" 2>&1
	exit 1
fi

if [ ! -f $name.sqfs ]; then
	echo "Run me from the directory with $name.sqfs"
	exit 1
fi

generic_mount() {
 [ ! -d $2/dev ] && mount -t squashfs -o loop "$1" $2
 [ ! -d $4/dev ] && mount -t aufs -o dirs=$3=rw:$2=rr none "$4"
)

mkdir -p $name{,-ro,-rw}

generic-mount $name.sqfs $name-ro $name-rw $name
cd $name

./chroot-dropbear.sh "$@"
# Try to unmount things
umount $name
umount $name-ro
