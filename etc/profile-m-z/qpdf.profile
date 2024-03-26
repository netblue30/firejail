# Firejail profile for qpdf
# Description: A Content-Preserving PDF Transformation System
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include qpdf.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
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
tracelog
x11 none

private-bin qpdf
private-cache
private-dev
private-etc
private-lib libqpdf.so.*
#private-tmp # breaks on Arch Linux

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
read-only ${HOME}
read-write ${DOCUMENTS}
read-write ${DOWNLOADS}
