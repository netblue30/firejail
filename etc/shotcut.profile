# Firejail profile for shotcut
# This file is overwritten after every install/update
# Persistent local customizations
include shotcut.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Meltytech

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix
seccomp
shell none

#private-bin shotcut,melt,qmelt,nice
private-cache
private-dev

#noexec ${HOME}
noexec /tmp
