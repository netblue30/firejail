# Firejail profile for tracker
# Description: Metadata database, indexer and search tool
# This file is overwritten after every install/update
# Persistent local customizations
include tracker.local
# Persistent global definitions
include globals.local

# Tracker is started by systemd on most systems. Therefore it is not firejailed by default

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin tracker
# private-dev
#private-etc alternatives,dbus-1,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,passwd,xdg
# private-tmp
