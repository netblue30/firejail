# Firejail profile for dexios
# Description: CLI encryption tool
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include dexios.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
include whitelist-run-common.inc
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
noprinters
noroot
nosound
notv
nou2f
novideo
seccomp.drop socket
seccomp.block-secondary
tracelog
x11 none

disable-mnt
private-bin dexios
private-cache
private-dev
private-etc
private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
read-write ${DOWNLOADS}
restrict-namespaces
