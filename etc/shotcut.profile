# Firejail profile for shotcut
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/shotcut.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Meltytech

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix
seccomp
shell none

#private-bin shotcut,melt,qmelt,nice
private-cache
private-dev

#noexec ${HOME}
noexec /tmp
