# Firejail profile for qpdfview
# Description: Tabbed document viewer
# This file is overwritten after every install/update
# Persistent local customizations
include qpdfview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/qpdfview
noblacklist ${HOME}/.local/share/qpdfview
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
machine-id
# needs D-Bus when started from a file manager
#nodbus
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

private-bin qpdfview
private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp
