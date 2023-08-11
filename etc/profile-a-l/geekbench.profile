# Firejail profile for geekbench
# Description: A cross-platform benchmark that measures processor and memory performance
# This file is overwritten after every install/update
# Persistent local customizations
include geekbench.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.geekbench5
noblacklist /sbin
noblacklist /usr/sbin

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.geekbench5
whitelist ${HOME}/.geekbench5
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
#private-bin bash,geekbench*,sh # #4576
private-cache
private-dev
private-etc lsb-release
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
read-write ${HOME}/.geekbench5
restrict-namespaces
