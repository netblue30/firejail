# Firejail profile for openttd
# Description: Transport system simulation game
# This file is overwritten after every install/update
# Persistent local customizations
include openttd.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.openttd

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.openttd
whitelist ${HOME}/.openttd
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin openttd
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
