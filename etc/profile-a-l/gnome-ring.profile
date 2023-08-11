# Firejail profile for gnome-ring
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-ring.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/gnome-ring

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
#private-dev
private-tmp

restrict-namespaces
