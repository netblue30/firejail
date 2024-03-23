# Firejail profile for tqemu
# Description: QEMU frontend without libvirt
# This file is overwritten after every install/update
# Persistent local customizations
include tqemu.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-programs.inc

# For host-only network sys_admin is needed.
# See https://github.com/netblue30/firejail/issues/2868#issuecomment-518647630
caps.keep net_raw,sys_nice
#caps.keep net_raw,sys_admin
netfilter
nodvd
notv
tracelog

private-cache
private-tmp

noexec /tmp
# breaks app
#restrict-namespaces
