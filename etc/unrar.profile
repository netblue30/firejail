# Firejail profile for unrar
# Description: Unarchiver for .rar files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include unrar.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
hostname unrar
ipc-namespace
machine-id
net none
no3d
nodbus
nodvd
#nogroups
nonewprivs
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin unrar
private-dev
private-etc alternatives,group,localtime,passwd
private-tmp
