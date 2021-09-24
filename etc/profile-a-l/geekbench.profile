# Firejail profile for geekbench
# Description: A cross-platform benchmark that measures processor and memory performance
# This file is overwritten after every install/update
# Persistent local customizations
include geekbench.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
hostname geekbench
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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin bash,geekbenc*,sh
private-cache
private-dev
private-etc alternatives,group,ld.so.preload,lsb-release,passwd
private-lib gcc/*/*/libstdc++.so.*
private-opt none
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute - breaks on Arch (see issue #1803)
read-only ${HOME}
