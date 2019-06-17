# Firejail profile for udiskie
# Description: Removable disk automounter using udisks
# This file is overwritten after every install/update
# Persistent local customizations
include udiskie.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

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
net none
no3d
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

private-bin awk,cut,dbus-send,egrep,file,grep,head,python,python3,readlink,sed,sh,udiskie,uname,which,xdg-mime,xdg-open,xprop
# add your configured file browser in udiskie.local, e. g.
# private-bin nautilus
# private-bin thunar
private-cache
private-dev
private-etc ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,alternatives,mime.types,xdg
private-tmp
