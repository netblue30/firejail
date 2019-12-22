# Firejail profile for ar
# Description: Create, modify, and extract from archives
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ar.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
hostname ar
ipc-namespace
machine-id
net none
no3d
nodbus
nodvd
nogroups
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
x11 none

private-bin ar
private-cache
private-dev
#private-etc alternatives,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,passwd,xdg

memory-deny-write-execute
