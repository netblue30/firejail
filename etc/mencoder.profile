# Firejail profile for mencoder
# Description: Free command line video decoding, encoding and filtering tool
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mencoder.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.mplayer

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# apparmor
caps.drop all
net none
no3d
nodbus
nogroups
nonewprivs
noroot
nosound
notv
nou2f
protocol unix
seccomp
shell none

disable-mnt
private-bin mencoder
private-cache
private-dev
private-etc mplayer
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
