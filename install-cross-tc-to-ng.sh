#!/bin/bash
set -e
set -x

if [ $(id -u) -ne 0 ]; then
	echo "please run me with sudo" 2>&1
	exit 1
fi

# Okay so this just grabs a few of the host system libraries. Maybe a "bit" fragile :P
if [ ! -e dchrt-ng/lib64 ]; then
 mkdir -p dchrt-ng/lib64
 cp -vL /lib64/ld-linux-x86-64.so.2 dchrt-ng/lib64
 mkdir -p dchrt-ng/usr/lib/x86_64
 for l in libc.so.6 libdl.so.2 libfl.so.2 libm.so.6; do
  cp -vL /usr/lib/$l dchrt-ng/usr/lib/x86_64/
 done
fi

# Copy the toolchain, remove the "external" sysroot and link to the root of dchrt for that.
rm -rf dchrt-ng/usr/ngcc-x64
cp -a ngcc-x64 dchrt-ng/usr
rm -r dchrt-ng/usr/ngcc-x64/sysroot
ln -s ../.. dchrt-ng/usr/ngcc-x64/sysroot

# If there's a helper file for ngcc, accompany it with the -x64 file (this is just incase username different or something weird)
if [ -f dchrt-ng/home/builder/ngcc ]; then
cat > dchrt-ng/home/builder/ngcc-x64 << "EOF"
export PATH=/usr/ngcc-x64/bin:/usr/bin:/bin
export CXX=g++
export CC=gcc
EOF
chown 1000:100 dchrt-ng/home/builder/ngcc-x64
fi
