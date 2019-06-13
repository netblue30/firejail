# Firejail profile for file
# Description: Recognize the type of data in a file using "magic" numbers
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include file.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
hostname file
ipc-namespace
machine-id
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

#private-bin file
private-cache
private-dev
private-etc alternatives,localtime,magic,magic.mgc
private-lib libarchive.so.*,libfakeroot,libmagic.so.*

memory-deny-write-execute
