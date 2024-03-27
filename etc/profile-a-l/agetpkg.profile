# Firejail profile for agetpkg
# Description: CLI tool to list/get/install packages from the Arch Linux Archive
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include agetpkg.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

# Allow python (blacklisted by disable-interpreters.inc)
#include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
protocol inet,inet6
seccomp
tracelog

private-bin agetpkg,python3
private-cache
private-dev
private-etc @tls-ca
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
