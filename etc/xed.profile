# Firejail profile for xed
# This file is overwritten after every install/update
# Persistent local customizations
include xed.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xed
noblacklist ${HOME}/.python-history
noblacklist ${HOME}/.python_history
noblacklist ${HOME}/.pythonhist

# Allow python (blacklisted by disable-interpreters.inc)
include	allow-python2.inc
include	allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
machine-id
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

private-bin xed
private-dev
#private-etc Trolltech.conf,X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp

# xed uses python plugins, memory-deny-write-execute breaks python
# memory-deny-write-execute
