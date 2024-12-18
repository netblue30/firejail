# Firejail profile for daisy
# Description: TUI scientific calculator with support for units
# This file is overwritten after every install/update
# Persistent local customizations
include daisy.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
#include disable-x11.inc # x11 none
include disable-xdg.inc

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
noprinters
noroot
nosound
notv
nou2f
novideo
# block socket syscall to simulate empty protocol option (see #639)
seccomp socket
seccomp.block-secondary
tracelog
x11 none

disable-mnt
private-bin daisy
private-cache
private-dev
private-etc
private-lib
private-opt none
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
restrict-namespaces
