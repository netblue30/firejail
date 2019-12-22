# Firejail profile for wireshark
# Description: Network traffic analyzer
# This file is overwritten after every install/update
# Persistent local customizations
include wireshark.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/wireshark
noblacklist ${HOME}/.wireshark
noblacklist ${DOCUMENTS}

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/wireshark
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
# caps.drop all
caps.keep dac_override,net_admin,net_raw
netfilter
no3d
# nogroups - breaks network traffic capture for unprivileged users
# nonewprivs - breaks network traffic capture for unprivileged users
# noroot
nodvd
nosound
notv
nou2f
novideo
# protocol unix,inet,inet6,netlink
# seccomp - breaks network traffic capture for unprivileged users
shell none
tracelog

# private-bin wireshark
private-dev
private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

