# Firejail profile for xviewer
# This file is overwritten after every install/update
# Persistent local customizations
include xviewer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.config/xviewer
noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.steam

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
# net none - makes settings immutable
no3d
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

private-bin xviewer
private-dev
#private-etc Trolltech.conf,X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-lib
private-tmp

memory-deny-write-execute
