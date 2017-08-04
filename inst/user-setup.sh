#!/bin/bash
# Meant for the container or chroot use, does away with the first run wizard

if [ -f /etc/pandora/first-boot ]; then
	echo "First boot process already done, not re-doing user-setup.sh"
	exit 0
fi

# Editables
username=builder
hostname=dchrt-ng


groupadd wheel
passwd -d root
useradd -c "Builder,,," -G adm,audio,cdrom,netdev,plugdev,users,video,wheel,dialout $username
passwd -d $username
echo $hostname > /etc/hostname
echo "127.0.0.1 localhost.localdomain localhost $hostname" > /etc/hosts
# Enable autologin just in case you do end up booting it...
sed -i "s/.*default_user.*/default_user $username/g" /etc/slim.conf
sed -i 's/.*auto_login.*/auto_login yes/g' /etc/slim.conf

#I dont setup some stuff that i cba to think about now (timezones, meh)

update-rc.d -f samba remove
update-rc.d -f xinetd remove
update-rc.d -f avahi-daemon remove
update-rc.d -f apmd remove
update-rc.d -f banner remove
update-rc.d -f portmap remove
update-rc.d -f mountnfs remove
update-rc.d -f blueprobe remove
update-rc.d -f dropbear remove
update-rc.d -f wl1251-init remove

# Give the builder a "hint" on how to use the new gcc
cat > /home/$username/ngcc << "EOF"
export PATH=/usr/ngcc/bin:/usr/bin:/bin
export CXX=g++
export CC=gcc
EOF
chown 1000:100 /home/$username/ngcc

touch /etc/pandora/first-boot
chmod 0666 /etc/pandora/first-boot

