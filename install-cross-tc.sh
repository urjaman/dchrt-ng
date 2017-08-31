#!/bin/bash

TGT="$1"
[ -z "$TGT" ] && TGT="dchrt-ng"

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
