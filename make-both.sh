#!/bin/bash
set -e
set -x
./make-chroot.sh
sudo rm -vf dchrt-ng/chroot-dropbear.sh
./make-container-post.sh
