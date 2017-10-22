# Firejail profile for shotcut
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/shotcut.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

noblacklist ${HOME}/.config/Meltytech

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix
seccomp
shell none

#private-bin shotcut,melt,qmelt,nice
private-dev

#noexec ${HOME}
noexec /tmp
