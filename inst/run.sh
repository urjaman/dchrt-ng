#!/bin/bash
set -x
set -e
cd /inst

# Firstly, run the opkg post-install stuff
if [ -e /etc/rcS.d/S40configure ]; then
	opkg-cl configure
	rm -f /etc/rcS.d/S40configure
fi

# Add the dev-feed
cp szdev-feed.conf /etc/opkg/

# Load the feeds
opkg update

# Install all the dev packages
opkg install $(echo `cat packages.txt`)

# Upgrading is hard.
opkg remove binutils-symlinks ncurses-tools --force-depends

# Finish all the upgrades
opkg upgrade

# Delete files used only in the installation
rm -rf /inst
