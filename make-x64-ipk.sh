#!/bin/bash
set -e
set -x

TGT=ngcc-ipk

# Create the cross toolchain if not built yet.
[ ! -d ngcc-x64 ] && ./make-cross-tc.sh

# Install the cross toolchain and related binaries

# Okay so this just grabs a few of the host system libraries. Maybe a "bit" fragile :P
if [ ! -e $TGT/lib64 ]; then
 mkdir -p $TGT/lib64
 cp -vL /lib64/ld-linux-x86-64.so.2 $TGT/lib64
 mkdir -p $TGT/usr/lib/x86_64
 for l in libc.so.6 libdl.so.2 libfl.so.2 libm.so.6; do
  cp -vL /usr/lib/$l $TGT/usr/lib/x86_64/
 done
fi

# Copy the toolchain, remove the "external" sysroot and link to the root of dchrt for that.
rm -rf $TGT/usr/ngcc-x64
cp -a ngcc-x64 $TGT/usr
rm -rf $TGT/usr/ngcc-x64/sysroot
ln -s ../.. $TGT/usr/ngcc-x64/sysroot

# Strip the binaries
strip --strip-unneeded $TGT/usr/ngcc-x64/libexec/gcc/armv7l-unknown-linux-gnueabi/*/* || true
strip --strip-unneeded $TGT/usr/ngcc-x64/bin/* || true
$TGT/usr/ngcc-x64/bin/strip --strip-debug $TGT/usr/ngcc-x64/armv7l-unknown-linux-gnueabi/lib/*.so.* || true

# Include the su hack, build it if needed.
[ ! -f busybox/busybox ] && ./build-su-hack.sh
cp -v busybox/busybox $TGT/usr/ngcc-x64/bin/su
chmod +s $TGT/usr/ngcc-x64/bin/su

# Make the ipk
X64_IPK_REV=1
X64_IPK=toolchain-x64-1.0-r$X64_IPK_REV.ipk

make_ipk_control() {
	echo "Package: toolchain-x64"
	echo "Version: 1.0-r$X64_IPK_REV"
	echo "Description: Container x86-64 to arm cross toolchain binaries"
	echo "Section: extras"
	echo "Priority: optional"
	echo "Maintainer: dchrt-ng"
	echo "License: none"
	echo "Architecture: armv7"
}

rm -f $X64_IPK
mkdir -p ipk-tmp
make_ipk_control > ipk-tmp/control
(cd ipk-tmp; tar -czf control.tar.gz control; rm control)
echo "2.0" > ipk-tmp/debian-binary
(cd $TGT; tar --group=root --owner=root -czf ../ipk-tmp/data.tar.gz *)
(cd ipk-tmp; ar -crf ../$X64_IPK debian-binary data.tar.gz control.tar.gz)
rm -rf ipk-tmp
