# Firejail profile for gfeeds
# Description: RSS/Atom feed reader for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gfeeds.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/org.gabmus.gfeeds
noblacklist ${HOME}/.config/org.gabmus.gfeeds.json

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/org.gabmus.gfeeds
mkfile ${HOME}/.config/org.gabmus.gfeeds.json
whitelist ${HOME}/.cache/org.gabmus.gfeeds
whitelist ${HOME}/.config/org.gabmus.gfeeds.json
whitelist /usr/share/gfeeds
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
#nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin gfeeds,python3*
# private-cache -- feeds are stored in ~/.cache
private-dev
private-etc X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,tor,xdg
private-tmp
