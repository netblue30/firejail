# Firejail profile for nano
# Description: nano is an easy text editor for the terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include nano.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.nanorc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/nano
include whitelist-usr-share-common.inc

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

# disable-mnt
private-bin nano,rnano
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nano,nanorc,passwd,xdg
# Comment the next line if you want to edit files in /etc directly

memory-deny-write-execute
