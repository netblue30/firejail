# Firejail profile for dbus-send
# Description: Send a message to a message bus
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include dbus-send.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-x11.inc
include disable-xdg.inc

#include whitelist-common.inc # see #903
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
#net none # breaks abstract sockets
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
protocol unix
seccomp
tracelog

disable-mnt
private
private-bin dbus-send
private-cache
private-dev
private-etc dbus-1
private-lib libpcre*
private-tmp

memory-deny-write-execute
read-only ${HOME}
restrict-namespaces
