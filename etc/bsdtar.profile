# Firejail profile for bsdtar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include bsdtar.local
# Persistent global definitions
include globals.local

include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
hostname bsdtar
ipc-namespace
machine-id
net none
no3d
nodvd
nodbus
nogroups
nonewprivs
# noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

# support compressed archives
private-bin bash,bsdcat,bsdcpio,bsdtar,bzip2,compress,gtar,gzip,lbzip2,libarchive,lz4,lzip,lzma,lzop,sh,xz
private-cache
private-dev
private-etc alternatives,group,localtime,passwd

memory-deny-write-execute
