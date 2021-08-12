# Firejail profile for strings
# Description: print the strings of printable characters in files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include strings.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
#include disable-programs.inc
include disable-shell.inc
#include disable-xdg.inc

#include whitelist-usr-share-common.inc
#include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog
x11 none

#private
#private-bin strings
private-cache
private-dev
#private-etc alternatives
#private-lib libfakeroot
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
