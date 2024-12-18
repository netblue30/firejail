# Firejail profile for patch
# Description: Apply a diff file to an original
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include patch.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

noblacklist ${DOCUMENTS}
noblacklist ${PATH}/patch

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
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
protocol unix
seccomp
seccomp.block-secondary
tracelog
x11 none

private-bin patch,red
private-dev
private-lib libdl.so.*,libfakeroot

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
