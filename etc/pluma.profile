# Firejail profile for pluma
# Description: Official text editor of the MATE desktop environment
# This file is overwritten after every install/update
# Persistent local customizations
include pluma.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/enchant
noblacklist ${HOME}/.config/pluma

# Allows files commonly used by IDEs
include allow-common-devel.inc

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

private-bin pluma
private-dev
private-etc Trolltech.conf,X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-lib aspell,gconv,libgspell-1.so.*,libreadline.so.*,libtinfo.so.*,pluma
private-tmp

memory-deny-write-execute

join-or-start pluma
