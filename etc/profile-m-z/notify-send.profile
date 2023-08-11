# Firejail profile for notify-send
# Description: a program to send desktop notifications
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include notify-send.local
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
include disable-xdg.inc

#include whitelist-common.inc # see #903
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
protocol unix
seccomp
tracelog
x11 none

disable-mnt
private
private-bin notify-send
private-cache
private-dev
private-etc
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-system none

memory-deny-write-execute
read-only ${HOME}
restrict-namespaces
