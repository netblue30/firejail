# Firejail profile for leafpad
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/leafpad.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/leafpad

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

private-dev

noexec ${HOME}
noexec /tmp
