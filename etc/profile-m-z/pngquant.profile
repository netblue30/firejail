# Firejail profile for pngquant
# Description: PNG converter and lossy image compressor
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include pngquant.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

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
noroot
nosound
notv
nou2f
novideo
# block the socket syscall to simulate an be empty protocol line, see #639
seccomp socket
tracelog
x11 none

private-bin pngquant
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
