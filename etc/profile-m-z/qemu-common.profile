# Firejail profile for QEMU
# Description: Machine & userspace emulator and virtualizer
# This file is overwritten after every install/update
# Persistent local customizations
include qemu-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

include disable-common.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
tracelog

private-cache
private-tmp

noexec /tmp
restrict-namespaces
