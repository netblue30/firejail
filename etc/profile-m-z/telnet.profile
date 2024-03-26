# Firejail profile for telnet
# Description: standard telnet client
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include telnet.local
# Persistent global definitions
include globals.local

noblacklist ${PATH}/telnet

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
#include disable-shell.inc
include disable-write-mnt.inc
include disable-x11.inc
include disable-xdg.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
tracelog

#disable-mnt
#private-bin PROGRAMS
private-cache
private-dev
#private-etc FILES
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
noexec ${HOME}
restrict-namespaces
