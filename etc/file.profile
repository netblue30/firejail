# Firejail profile for file
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/file.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
hostname file
net none
no3d
nodvd
nogroups
nonewprivs
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

private-bin file
private-dev
private-etc magic.mgc,magic,localtime

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
