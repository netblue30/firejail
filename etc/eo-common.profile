# Firejail profile for eo-common
# Description: Common profile for Eye of GNOME/MATE graphics viewer program
# This file is overwritten after every install/update
# Persistent local customizations
include eo-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.steam

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none
tracelog

private-cache
private-dev
private-etc X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,tor,xdg
private-lib eog,eom,gdk-pixbuf-2.*,gio,girepository-1.*,gvfs,libgconf-2.so.*
private-tmp
