# Firejail profile for dnsmasq
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dnsmasq.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist /sbin
noblacklist /usr/sbin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps
netfilter
no3d
nonewprivs
nosound
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
private
private-dev
notv
