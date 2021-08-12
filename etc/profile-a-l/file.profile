# Firejail profile for file
# Description: Recognize the type of data in a file using "magic" numbers
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include file.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

include disable-common.inc
include disable-exec.inc
include disable-programs.inc

apparmor
caps.drop all
hostname file
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
noinput
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
#private-etc alternatives,localtime,magic,magic.mgc
#private-lib file,libarchive.so.*,libfakeroot,libmagic.so.*,libseccomp.so.*

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
