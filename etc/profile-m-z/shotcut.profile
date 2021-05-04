# Firejail profile for shotcut
# Description: A free, open source, cross-platform video editor
# This file is overwritten after every install/update
# Persistent local customizations
include shotcut.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}/.config/Meltytech

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix
seccomp
shell none
tracelog

#private-bin melt,nice,qmelt,shotcut
private-cache
private-dev

dbus-user none
dbus-system none
