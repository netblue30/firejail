# Firejail profile for bitlbee
# Description: IRC to other chat networks gateway
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/bitlbee.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist /sbin
noblacklist /usr/sbin
# noblacklist /var/log

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

netfilter
no3d
nodvd
nonewprivs
nosound
notv
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private
private-cache
private-dev
private-tmp
read-write /var/lib/bitlbee

noexec /tmp
