# Firejail profile for assogiate
# Description: An editor of the MIME file types database for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include assogiate.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${PICTURES}
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
tracelog

disable-mnt
private-bin assogiate,gtk-update-icon-cache,update-mime-database
private-cache
private-dev
#private-etc X11,alternatives,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-lib gnome-vfs-2.0,libacl.so.*,libattr.so.*,libfam.so.*
private-tmp

memory-deny-write-execute
