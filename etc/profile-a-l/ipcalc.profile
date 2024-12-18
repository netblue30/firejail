# Firejail profile for ipcalc
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ipcalc.local
# Persistent global definitions
include globals.local

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
#include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

#include whitelist-common.inc # see #903
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
#machine-id
net none
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
#protocol unix
seccomp
#tracelog

disable-mnt
private
private-bin bash,ipcalc,ipcalc-ng,perl,sh
#private-cache
private-dev
# empty etc directory
private-etc
private-lib
private-opt none
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute
#read-only ${HOME}
restrict-namespaces
