# Firejail profile for nano
# Description: nano  is a easy text editor for the terminal
# This file is overwritten after every install/update
# Persistent local customizations
include nano.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.nanorc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

apparmor
caps.drop all
machine-id
net none
no3d
nodbus
nodvd
nogroups
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

disable-mnt
private-bin nano
private-cache
private-dev
private-etc nanorc
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
