# Firejail profile for dbus-send
# Description: Send a message to a message bus
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include dbus-send.local
# Persistent global definitions
include globals.local

deny  /tmp/.X11-unix
deny  ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
# Breaks abstract sockets
#net none
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
shell none
tracelog

disable-mnt
private
private-bin dbus-send
private-cache
private-dev
private-etc alternatives,dbus-1
private-lib libpcre*
private-tmp

memory-deny-write-execute
read-only ${HOME}
