# Firejail profile for atool
# Description: Tool for managing file archives of various types
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include atool.local
# Persistent global definitions
include globals.local

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
hostname atool
ipc-namespace
machine-id
net none
netfilter
no3d
nodvd
nodbus
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

# private-bin atool,perl
private-cache
private-dev
private-etc alternatives,atool.conf,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,passwd,xdg
# without login.defs atool complains and uses UID/GID 1000 by default
private-tmp

memory-deny-write-execute
