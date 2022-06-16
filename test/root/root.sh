#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2022 Firejail Authors
# License GPL v2

# set a new firejail config file
#cp firejail.config /etc/firejail/firejail.config

export LC_ALL=C

#********************************
# firecfg
#********************************
which less 2>/dev/null
if [ "$?" -eq 0 ];
then
	echo "TESTING: firecfg (test/root/firecfg.exp)"
	mv /home/netblue/.local/share/applications /home/netblue/.local/share/applications-store
	./firecfg.exp
	mv /home/netblue/.local/share/applications-store /home/netblue/.local/share/applications
else
	echo "TESTING SKIP: firecfg, less not found"
fi

#********************************
# servers
#********************************
if [ -f /etc/init.d/snmpd ]
then
	echo "TESTING: snmpd (test/root/snmpd.exp)"
	./snmpd.exp
else
	echo "TESTING SKIP: snmpd  not found"
fi


if [ -f /etc/init.d/apache2 ]
then
	echo "TESTING: apache2 (test/root/apache2.exp)"
	./apache2.exp
else
	echo "TESTING SKIP: apache2  not found"
fi

if [ -f /etc/init.d/isc-dhcp-server ]
then
	echo "TESTING: isc dhcp server (test/root/isc-dhscp.exp)"
	./isc-dhcp.exp
else
	echo "TESTING SKIP: isc dhcp server not found"
fi

if [ -f /etc/init.d/unbound ]
then
	echo "TESTING: unbound (test/root/unbound.exp)"
	./unbound.exp
else
	echo "TESTING SKIP: unbound  not found"
fi

if [ -f /etc/init.d/nginx ]
then
	echo "TESTING: nginx (test/root/nginx.exp)"
	./nginx.exp
else
	echo "TESTING SKIP: nginx  not found"
fi

#********************************
# filesystem
#********************************
echo "TESTING: fs private (test/root/private.exp)"
./private.exp

echo "TESTING: fs whitelist mnt, opt, media (test/root/whitelist-mnt.exp)"
./whitelist.exp

#********************************
# utils
#********************************
echo "TESTING: join (test/root/join.exp)"
./join.exp

echo "TESTING: login-nobody (test/root/login_nobody.exp)"
./login_nobody.exp

#********************************
# seccomp
#********************************
echo "TESTING: seccomp umount (test/root/seccomp-umount.exp)"
./seccomp-umount.exp

echo "TESTING: seccomp chmod (test/root/seccomp-chmod.exp)"
./seccomp-chmod.exp

echo "TESTING: seccomp chown (test/root/seccomp-chown.exp)"
./seccomp-chown.exp

#********************************
# command line options
#********************************
echo "TESTING: firejail configuration (test/root/checkcfg.exp)"
./checkcfg.exp
cp ../../etc/firejail.config /etc/firejail/.

echo "TESTING: tmpfs (test/root/option_tmpfs.exp)"
./option_tmpfs.exp

echo "TESTING: profile tmpfs (test/root/profile_tmpfs)"
./profile_tmpfs.exp

echo "TESTING: bind directory (test/root/option_bind_directory.exp)"
./option_bind_directory.exp

echo "TESTING: bind file (test/root/option_bind_file.exp)"
echo hello > tmpfile
./option_bind_file.exp
rm -f tmpfile

#********************************
# firemon
#********************************
echo "TESTING: firemon events (test/root/firemon-events.exp)"
./firemon-events.exp


# restore the default config file
#cp ../../etc/firejail.config /etc/firejail/firejail.config
