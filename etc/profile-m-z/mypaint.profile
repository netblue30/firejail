# Firejail profile for mypaint
# Description: A fast and easy graphics application for digital painters
# This file is overwritten after every install/update
# Persistent local customizations
include mypaint.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mypaint
noblacklist ${HOME}/.config/mypaint
noblacklist ${HOME}/.local/share/mypaint
noblacklist ${PICTURES}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

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

private-cache
private-dev
private-etc alternatives,dconf,fonts,gtk-3.0,ld.so.preload
private-tmp

dbus-user none
dbus-system none
