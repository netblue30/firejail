# Firejail profile for abiword
# Description: flexible cross-platform word processor
# This file is overwritten after every install/update
# Persistent local customizations
include abiword.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/abiword

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

whitelist /usr/share/abiword-3.0
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
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
tracelog

private-bin abiword
private-cache
private-dev
private-etc @x11
private-tmp

#dbus-user none
#dbus-system none

restrict-namespaces
