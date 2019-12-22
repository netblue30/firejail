# Firejail profile for display
# This file is overwritten after every install/update
# Persistent local customizations
include display.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
protocol unix
seccomp
shell none
# x11 xorg - problems on kubuntu 17.04

private-bin display,python*
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
# On Debian-based systems, display is a symlink in /etc/alternatives
private-tmp
