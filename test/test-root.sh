#!/bin/bash

./chk_config.exp

echo "TESTING: tmpfs"
./option_tmpfs.exp

echo "TESTING: network interfaces"
./net_interface.exp

echo "TESTING: chroot"
./fs_chroot_asroot.exp

if [ -f /etc/init.d/snmpd ]
then
	echo "TESTING: servers snmpd, private-dev"
	./servers2.exp
fi

if [ -f /etc/init.d/apache2 ]
then
	echo "TESTING: servers apache2, private-dev"
	./servers3.exp
fi

if [ -f /etc/init.d/isc-dhcp-server ]
then
	echo "TESTING: servers isc dhcp server, private-dev"
	./servers4.exp
fi

if [ -f /etc/init.d/unbound ]
then
	echo "TESTING: servers unbound, private-dev"
	./servers5.exp
fi

if [ -f /etc/init.d/nginx ]
then
	echo "TESTING: servers nginx, private-dev"
	./servers6.exp
fi

echo "TESTING: /proc/sysrq-trigger reset disabled"
./sysrq-trigger.exp

echo "TESTING: seccomp umount"
./seccomp-umount.exp

echo "TESTING: seccomp chmod (seccomp lists)"
./seccomp-chmod.exp

echo "TESTING: seccomp chown (seccomp lists)"
./seccomp-chown.exp

echo "TESTING: bind directory"
./option_bind_directory.exp

echo "TESTING: bind file"
echo hello > tmpfile
./option_bind_file.exp
rm -f tmpfile

echo "TESTING: firemon --interface"
./firemon-interface.exp

if [ -f /sys/fs/cgroup/g1/tasks ]
then
	echo "TESTING: firemon --cgroup"
	./firemon-cgroup.exp
fi
