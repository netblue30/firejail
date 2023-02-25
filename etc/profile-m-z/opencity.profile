# Firejail profile for opencity
# Description: Full 3D city simulator game project
# This file is overwritten after every install/update
# Persistent local customizations
include opencity.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.opencity

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.opencity
whitelist ${HOME}/.opencity
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
protocol unix
seccomp
tracelog

disable-mnt
private-bin opencity
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
