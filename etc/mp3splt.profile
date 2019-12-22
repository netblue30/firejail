# Firejail profile for mp3splt
# Description: utility for mp3 splitting without decoding
# This file is overwritten after every install/update
# Persistent local customizations
include mp3splt.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

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
x11 none

disable-mnt
private-bin flacsplt,mp3splt,mp3wrap,oggsplt
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,passwd,xdg
private-tmp

memory-deny-write-execute
