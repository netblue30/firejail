# Firejail profile for nano
# Description: nano is an easy text editor for the terminal
# This file is overwritten after every install/update
# Persistent local customizations
include nano.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.nanorc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
ipc-namespace
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

# disable-mnt
private-bin nano,rnano
private-cache
private-dev
# Comment the next line if you want to edit files in /etc directly
private-etc alternatives,nanorc

memory-deny-write-execute
