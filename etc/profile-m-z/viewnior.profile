# Firejail profile for viewnior
# Description: Simple, fast and elegant image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include viewnior.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.config/viewnior
noblacklist ${HOME}/.steam

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

whitelist /usr/share/viewnior
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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

private-bin viewnior
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute # breaks on Arch (see issues #1803 and #1808)
restrict-namespaces
