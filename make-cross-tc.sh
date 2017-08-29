#!/bin/bash
set -e
set -x

MJ=-j6
PREFIX="$(pwd)/ngcc-x64"
TARGET=armv7l-unknown-linux-gnueabi

mkdir -p $PREFIX
if [ ! -e $PREFIX/sysroot ]; then
 mkdir $PREFIX/sysroot
 cp -a dchrt-ng/lib $PREFIX/sysroot/
 mkdir -p $PREFIX/sysroot/usr
 cp -a dchrt-ng/usr/{lib,include} $PREFIX/sysroot/usr/
 cd $PREFIX/sysroot/lib
 # cleanup some useless stuff (and the libc.so symlink is just harmful)
 rm -rf libc.so cpp modules udev dsp firmware
 cd ../../..
fi

mkdir -p tcsrc
cd tcsrc

#binutils and gdb
if [ ! -e binutils-gdb ]; then
 git clone git://sourceware.org/git/binutils-gdb.git
 cd binutils-gdb
 # 2.28
 git checkout 09e514a92b6bb7c910051a7fafc9fded8a687848
 cd ..
fi


#gcc and support stuff
if [ ! -e gcc ]; then
 git clone git://gcc.gnu.org/git/gcc.git
 wget https://ftp.gnu.org/gnu/gmp/gmp-4.3.2.tar.bz2
 wget https://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
 wget http://www.mpfr.org/mpfr-current/mpfr-3.1.5.tar.bz2
 cd gcc;
 # 7.1.1
 git checkout d791474f3fc2133fa0c310e566988b0cbdff321e
 tar xf ../gmp-*.tar.*; mv gmp-* gmp
 tar xf ../mpc-*.tar.*; mv mpc-* mpc
 tar xf ../mpfr-*.tar.*; mv mpfr-* mpfr
 cd ..
 rm gmp-*.tar.*  mpc-*.tar.* mpfr-*.tar.*
fi

#binutils
if [ ! -e bb ]; then
 mkdir bb; cd bb
 ../binutils-gdb/configure --prefix=$PREFIX --target=$TARGET --disable-nls --disable-gdb --disable-werror --without-isl --disable-multilib --with-sysroot=$PREFIX/sysroot
 make $MJ
 make install
 cd ..
fi

#gcc
if [ ! -e gb ]; then
 mkdir gb; cd gb
 ../gcc/configure --prefix=$PREFIX --target=$TARGET --disable-nls --with-sysroot=$PREFIX/sysroot \
       --enable-languages=c,c++ --disable-libssp --disable-libquadmath --without-isl \
       --disable-werror --disable-multilib
 make $MJ
 make install
fi

if [ ! -e $PREFIX/bin/gcc ]; then
 # We add some symlinks :)
 cd $PREFIX/bin
 for n in gcc g++ ar as c++ cpp ld nm objcopy objdump ranlib readelf size strings strip; do
   ln -s $TARGET-$n $n
 done
fi
