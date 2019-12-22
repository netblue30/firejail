# Firejail profile for gnome-documents
# Description: Document manager for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-documents.local
# Persistent global definitions
include globals.local

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.config/libreoffice
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
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

private-cache
private-dev
#private-etc X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp

