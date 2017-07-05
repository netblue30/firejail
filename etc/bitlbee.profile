# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/bitlbee.local

# BitlBee instant messaging profile
noblacklist /sbin
noblacklist /usr/sbin
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

netfilter
no3d
nonewprivs
private
private-dev
protocol unix,inet,inet6
seccomp
nosound
novideo
read-write /var/lib/bitlbee

private-dev
private-tmp
disable-mnt

noexec /tmp
