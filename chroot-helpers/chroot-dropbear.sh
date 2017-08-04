#!/bin/sh
# Chroot gracely into dchrt
DROPBEAR_PORT=4434
if [ $(id -u) -ne 0 ]; then
	echo "please run me with sudo or as root with your username as the parameter" 2>&1
	exit 1
fi

if [ ! -e dev/ptmx ]; then
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

echo "Mounting chroot"
mount -t proc proc proc/
mount -t sysfs sys sys/
mount -o bind /dev dev/
mount -t devpts pts dev/pts/
mount -t tmpfs tmpfs tmp
if [ -f /etc/resolv.conf ]; then
	cp -L /etc/resolv.conf etc/resolv.conf
fi

echo "You should be able to login with ssh builder@127.0.0.1 -p $DROPBEAR_PORT or root@..."
/usr/sbin/chroot . /usr/sbin/dropbear -s -F -E -R -p 127.0.0.1:$DROPBEAR_PORT

echo "Unmounting chroot"
umount proc
umount sys
umount dev/pts
umount dev
umount tmp
if [ -f etc/resolv.conf ]; then
	rm etc/resolv.conf
fi
