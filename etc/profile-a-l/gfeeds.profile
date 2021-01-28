# Firejail profile for gfeeds
# Description: RSS/Atom feed reader for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gfeeds.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/gfeeds
noblacklist ${HOME}/.cache/org.gabmus.gfeeds
noblacklist ${HOME}/.config/org.gabmus.gfeeds.json
noblacklist ${HOME}/.config/org.gabmus.gfeeds.saved_articles

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/gfeeds
mkdir ${HOME}/.cache/org.gabmus.gfeeds
mkfile ${HOME}/.config/org.gabmus.gfeeds.json
mkdir ${HOME}/.config/org.gabmus.gfeeds.saved_articles
whitelist ${HOME}/.cache/gfeeds
whitelist ${HOME}/.cache/org.gabmus.gfeeds
whitelist ${HOME}/.config/org.gabmus.gfeeds.json
whitelist ${HOME}/.config/org.gabmus.gfeeds.saved_articles
whitelist /usr/share/gfeeds
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
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
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin gfeeds,python3*
# private-cache -- feeds are stored in ~/.cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,group,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,X11,xdg
private-tmp

dbus-user filter
dbus-user.own org.gabmus.gfeeds
dbus-user.talk ca.desrt.dconf
dbus-system none
