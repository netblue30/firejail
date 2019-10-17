# Firejail profile for uudeview
# Description: Smart multi-file multi-part decoder
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include uudeview.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc

caps.drop all
hostname uudeview
ipc-namespace
machine-id
net none
nodbus
nodvd
#nogroups
nonewprivs
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

private-bin uudeview
private-cache
private-dev
private-etc alternatives,ld.so.preload
