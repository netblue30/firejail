# Firejail profile for dig
# Description: DNS lookup utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include dig.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.digrc
noblacklist ${PATH}/dig

blacklist ${RUNUSER}

include disable-common.inc
#include disable-devel.inc
include disable-exec.inc
#include disable-interpreters.inc
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

#mkfile ${HOME}/.digrc # see #903
whitelist ${HOME}/.digrc
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
private-bin bash,dig,sh
private-dev
private-etc
# Add the next line to your dig.local on non Debian/Ubuntu OS (see issue #3038).
#private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
