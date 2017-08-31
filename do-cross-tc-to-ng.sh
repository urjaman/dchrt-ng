#!/bin/bash
set -e
set -x

if [ $(id -u) -ne 0 ]; then
	echo "please run me with sudo" 2>&1
	exit 1
fi

./install-cross-tc.sh

# If there's a helper file for ngcc, accompany it with the -x64 file (this is just incase username different or something weird)
if [ -f dchrt-ng/home/builder/ngcc ]; then
cat > dchrt-ng/home/builder/ngcc-x64 << "EOF"
export PATH=/usr/ngcc-x64/bin:/usr/sbin:/usr/bin:/sbin:/bin
export CXX=g++
export CC=gcc
EOF
chown 1000:100 dchrt-ng/home/builder/ngcc-x64
# and have it be the default compiler
echo ". ~/ngcc-x64" >> dchrt-ng/home/builder/.bashrc
fi
