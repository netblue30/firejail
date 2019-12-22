# Firejail profile for clipit
# Description: Lightweight GTK+ clipboard manager
# This file is overwritten after every install/update
# Persistent local customizations
include clipit.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/clipit
noblacklist ${HOME}/.local/share/clipit

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/clipit
mkdir ${HOME}/.local/share/clipit
whitelist ${HOME}/.config/clipit
whitelist ${HOME}/.local/share/clipit
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
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

disable-mnt
private-cache
private-dev
#private-etc X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp

