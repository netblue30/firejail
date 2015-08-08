#!/bin/bash

./chk_config.exp

echo "TESTING: servers rsyslogd, sshd, nginx"
./servers.exp

if [ -f /etc/init.d/snmpd ]
then
	echo "TESTING: servers snmpd"
	./servers2.exp
fi

if [ -f /etc/init.d/apache2 ]
then
	echo "TESTING: servers apache2"
	./servers3.exp
fi

if [ -f /etc/init.d/isc-dhcp-server ]
then
	echo "TESTING: servers isc dhcp server"
	./servers4.exp
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

echo "TESTING: chroot"
./fs_chroot.exp

echo "TESTING: firemon --interface"
./firemon-interface.exp

if [ -f /sys/fs/cgroup/g1/tasks ]
then
	echo "TESTING: firemon --cgroup"
	./firemon-cgroup.exp
fi
