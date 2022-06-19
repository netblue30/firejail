# Firejail profile for gpicview
# Description: Lightweight image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gpicview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gpicview

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

whitelist /usr/share/gpicview
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
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
tracelog

private-bin gpicview
private-cache
private-dev
private-etc alternatives,fonts,group,ld.so.cache,ld.so.preload,passwd
private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
