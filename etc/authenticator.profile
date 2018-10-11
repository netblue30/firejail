# Firejail profile for authenticator
# Description: 2FA code generator for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/authenticator.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklisted in 'disable-programs.local'
noblacklist ${HOME}/.config/Authenticator

# Allow python 3.x (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# apparmor
caps.drop all
net none
no3d
# nodbus - makes settings immutable
nodvd
nogroups
nonewprivs
noroot
nosound
notv
# novideo
nou2f
protocol unix
seccomp
shell none

disable-mnt
# private-bin authenticator
private-cache
private-dev
private-etc fonts,ld.so.cache
# private-lib
private-tmp

# memory-deny-write-execute - breaks on Arch
noexec ${HOME}
noexec /tmp
