# Firejail profile for qemu-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include qemu-launcher.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.qemu-launcher

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
