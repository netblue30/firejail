# Firejail profile for mdr
# Description: A standalone Markdown renderer for the terminal
# Persistent local customizations
include mdr.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
hostname mdr
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
protocol unix
seccomp
tracelog
x11 none

disable-mnt
private-bin mdr
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload
private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
