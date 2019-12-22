# Firejail profile for clawsker
# Description: An applet to edit Claws Mail's hidden preferences
# This file is overwritten after every install/update
# Persistent local customizations
include clawsker.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.claws-mail

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.claws-mail
whitelist ${HOME}/.claws-mail
whitelist /usr/share/perl5
include whitelist-common.inc
include whitelist-usr-share-common.inc

apparmor
caps.drop all
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

disable-mnt
private-bin bash,clawsker,perl,sh,which
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,tor,xdg
private-lib girepository-1.*,libdbus-glib-1.so.*,libetpan.so.*,libgirepository-1.*,libgtk-x11-2.0.so.*,libstartup-notification-1.so.*,perl*
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)
