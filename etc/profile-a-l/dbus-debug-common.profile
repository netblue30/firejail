# Firejail profile for dbus-debug-common
# This file is overwritten after every install/update
# Persistent local customizations
include dbus-debug-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
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

disable-mnt
private-cache
private-dev
private-etc dbus-1
private-tmp

read-only ${HOME}
restrict-namespaces
