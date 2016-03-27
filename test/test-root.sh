#!/bin/bash

./chk_config.exp

echo "TESTING: tmpfs (option_tmpfs.exp)"
./option_tmpfs.exp

echo "TESTING: profile tmpfs (profile_tmpfs)"
./profile_tmpfs.exp

echo "TESTING: network interfaces (net_interface.exp)"
./net_interface.exp

echo "TESTING: chroot (fs_chroot_asroot.exp)"
./fs_chroot_asroot.exp

if [ -f /etc/init.d/snmpd ]
then
	echo "TESTING: servers snmpd, private-dev (servers2.exp)"
	./servers2.exp
fi

if [ -f /etc/init.d/apache2 ]
then
	echo "TESTING: servers apache2, private-dev, private-tmp (servers3.exp)"
	./servers3.exp
fi

if [ -f /etc/init.d/isc-dhcp-server ]
then
	echo "TESTING: servers isc dhcp server, private-dev (servers4.exp)"
	./servers4.exp
fi

if [ -f /etc/init.d/unbound ]
then
	echo "TESTING: servers unbound, private-dev, private-tmp (servers5.exp)"
	./servers5.exp
fi

if [ -f /etc/init.d/nginx ]
then
	echo "TESTING: servers nginx, private-dev, private-tmp (servers6.exp)"
	./servers6.exp
fi

echo "TESTING: /proc/sysrq-trigger reset disabled (sysrq-trigger.exp)"
./sysrq-trigger.exp

echo "TESTING: seccomp umount (seccomp-umount.exp)"
./seccomp-umount.exp

echo "TESTING: seccomp chmod (seccomp-chmod.exp)"
./seccomp-chmod.exp

echo "TESTING: seccomp chown (seccomp-chown.exp)"
./seccomp-chown.exp

echo "TESTING: bind directory (option_bind_directory.exp)"
./option_bind_directory.exp

echo "TESTING: bind file (option_bind_file.exp)"
echo hello > tmpfile
./option_bind_file.exp
rm -f tmpfile

echo "TESTING: firemon --interface (firemon-interface.exp)"
./firemon-interface.exp

if [ -f /sys/fs/cgroup/g1/tasks ]
then
	echo "TESTING: firemon --cgroup (firemon-cgroup.exp)"
	./firemon-cgroup.exp
fi

echo "TESTING: chroot resolv.conf (chroot-resolvconf.exp)"
rm -f tmpfile
touch tmpfile
rm -f /tmp/chroot/etc/resolv.conf
ln -s tmp /tmp/chroot/etc/resolv.conf
./chroot-resolvconf.exp
rm -f tmpfile
