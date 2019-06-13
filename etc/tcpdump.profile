# Firejail profile for tcpdump
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include tcpdump.local
# Persistent global definitions
include globals.local

noblacklist /sbin
noblacklist /usr/sbin
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc
include whitelist-common.inc

caps.keep net_raw
ipc-namespace
#net tun0
netfilter
no3d
nodvd
#nogroups
nonewprivs
#noroot
nosound
notv
nou2f
novideo

protocol unix,inet,inet6,netlink,packet
seccomp

disable-mnt
#private
#private-bin tcpdump
private-dev
#private-etc
private-tmp

memory-deny-write-execute
