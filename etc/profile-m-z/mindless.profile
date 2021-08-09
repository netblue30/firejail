# Firejail profile for mindless
# Description: figure out the secret code
# This file is overwritten after every install/update
# Persistent local customizations
include mindless.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/mindless
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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
shell none
tracelog

disable-mnt
private
private-bin mindless
private-cache
private-dev
private-etc fonts
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
