# Firejail profile for keepassxc
# Description: Cross Platform Password Manager
# This file is overwritten after every install/update
# Persistent local customizations
include keepassxc.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.config/keepassxc
noblacklist ${HOME}/.keepassxc
# 2.2.4 needs this path when compiled with "Native messaging browser extension"
noblacklist ${HOME}/.mozilla
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/keepassxc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
net none
no3d
nodvd
# Breaks 'Lock database when session is locked or lid is closed' (#2899).
# Also breaks (Plasma) tray icon,
# you can safely uncomment it or add to keepassxc.local if you don't need these features.
#nodbus
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

private-bin keepassxc,keepassxc-cli,keepassxc-proxy
private-dev
private-etc Trolltech.conf,X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,tor,xdg
private-tmp

# Mutex is stored in /tmp by default, which is broken by private-tmp
join-or-start keepassxc
