# Firejail profile for xreader
# Description: Document viewer for files like PDF and Postscript. X-Apps Project.
# This file is overwritten after every install/update
# Persistent local customizations
include xreader.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/xreader
noblacklist ${HOME}/.config/xreader
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

# Breaks xreader on Mint 18.3
# include whitelist-var-common.inc

# apparmor
caps.drop all
no3d
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

private-bin xreader,xreader-previewer,xreader-thumbnailer
private-dev
private-etc Trolltech.conf,X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp

memory-deny-write-execute
