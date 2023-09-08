# Firejail profile for kazam
# Description: Screen capture tool
# This file is overwritten after every install/update
# Persistent local customizations
include kazam.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${PICTURES}
noblacklist ${VIDEOS}
noblacklist ${HOME}/.config/kazam

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/kazam
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
tracelog

disable-mnt
#private-bin kazam,python*
private-cache
private-dev
private-etc @x11
private-tmp

dbus-system none

restrict-namespaces
