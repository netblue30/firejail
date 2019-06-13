# Firejail profile for devhelp
# Description: API documentation browser for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include devhelp.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc

apparmor
caps.drop all
# net none - makes settings immutable
# nodbus - makes settings immutable
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

disable-mnt
private-bin devhelp
private-cache
private-dev
private-etc alternatives,dconf,fonts,ld.so.cache,machine-id,ssl
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue 1803)

read-only ${HOME}
