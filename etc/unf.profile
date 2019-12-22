# Firejail profile for unf
# Description: UNixize Filename -- replace annoying anti-unix characters in filenames
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include unf.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
hostname unf
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
private-bin unf
private-cache
?HAS_APPIMAGE: ignore private-dev
private-etc alternatives,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,passwd,xdg
private-dev
private-lib libgcc_s.so.*
private-tmp

memory-deny-write-execute
