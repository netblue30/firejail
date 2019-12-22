# Firejail profile for highlight
# Description: Universal source code to formatted text converter
# This file is overwritten after every install/update
# Persistent local customizations
include highlight.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
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

private-bin highlight
private-cache
private-dev
#private-etc alternatives,higL,highlight,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,passwd,xdg
private-tmp
