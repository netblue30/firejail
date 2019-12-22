# Firejail profile for pngquant
# Description: PNG converter and lossy image compressor
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include pngquant.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

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
# protocol can be empty, but this is not yet supported see #639
protocol inet
seccomp
shell none
tracelog
x11 none

private-bin pngquant
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,passwd,xdg
private-tmp

memory-deny-write-execute
