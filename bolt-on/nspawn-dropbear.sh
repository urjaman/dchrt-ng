#!/bin/bash
DROPBEAR_PORT=4433
if [ $(id -u) -ne 0 ]; then
	echo "please run me with sudo or as root with your username as the parameter" 2>&1
	exit 1
fi
if [ ! -d dev/pts ]; then
	echo "Make sure your working directory is in dchrt" 2>&1
	exit 1
fi
# if you're just rolling as root...
USERHOME=$HOME
# have an username?
if [ -n "$1" ]; then
	SUDO_USER="$1"
fi
# or sudo gives us an username?
if [ -n "$SUDO_USER" ]; then
	USERHOME="$(eval echo ~$SUDO_USER)"
fi
echo "home set $USERHOME"
if [ "$(ls $USERHOME/.ssh | grep id_ | grep pub | wc -l)" = "0" ]; then
	echo "Please make an ssh key for yourself using ssh-keygen"
	exit 1
fi
KEYS="$USERHOME/.ssh/id_*.pub"

mkdir -p home/{root,builder}/.ssh
cat $KEYS > home/root/.ssh/authorized_keys
cat $KEYS > home/builder/.ssh/authorized_keys
chown -R 1000:100 home/builder/.ssh
chown -R 0:0 home/root/.ssh
chmod 0700 home/{root,builder}/.ssh
chmod 0600 home/{root,builder}/.ssh/authorized_keys

# dchrt ships an x86_64 static qemu-arm ... the config file would work for other hosts, so adjust if you need to :P
if [ "$(uname -m)" = "x86_64" ]; then
	if [ -d  /etc/binfmt.d ]; then
		if [ ! -f /etc/binfmt.d/qemu-arm-static.conf ]; then
			cp qemu-arm-static.conf /etc/binfmt.d
			systemctl restart systemd-binfmt
			echo "Installed /etc/binfmt.d/qemu-arm-static.conf"
		fi
	fi
fi
echo "You should be able to login with ssh root@127.0.0.1 -p $DROPBEAR_PORT or builder@..."
systemd-nspawn -D "$(pwd)" -M dchrt /usr/sbin/dropbear -s -F -E -R -p 127.0.0.1:$DROPBEAR_PORT
