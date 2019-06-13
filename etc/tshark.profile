# Firejail profile for tshark
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include tshark.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc
include whitelist-common.inc

#caps.keep net_raw
caps.keep dac_override,net_admin,net_raw
ipc-namespace
#net tun0
netfilter
no3d
nodvd
# nogroups - breaks network traffic capture for unprivileged users
# nonewprivs - breaks network traffic capture for unprivileged users
# noroot
nosound
notv
nou2f
novideo

#protocol unix,inet,inet6,netlink,packet
#seccomp

disable-mnt
#private
private-cache
#private-bin tshark
private-dev
#private-etc
private-tmp

# memory-deny-write-execute
