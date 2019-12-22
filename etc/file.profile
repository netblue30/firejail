# Firejail profile for file
# Description: Recognize the type of data in a file using "magic" numbers
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include file.local
# Persistent global definitions
include globals.local

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

#private-bin bzip2,file,gzip,lrzip,lz4,lzip,xz,zstd
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,magic,mime.types,passwd,xdg
private-lib file,libarchive.so.*,libfakeroot,libmagic.so.*

memory-deny-write-execute
read-only ${HOME}
