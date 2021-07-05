# Firejail profile for gfeeds
# Description: RSS/Atom feed reader for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gfeeds.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/gfeeds
nodeny  ${HOME}/.cache/org.gabmus.gfeeds
nodeny  ${HOME}/.config/org.gabmus.gfeeds.json
nodeny  ${HOME}/.config/org.gabmus.gfeeds.saved_articles

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
allow  ${HOME}/.cache/gfeeds
allow  ${HOME}/.cache/org.gabmus.gfeeds
allow  ${HOME}/.config/org.gabmus.gfeeds.json
allow  ${HOME}/.config/org.gabmus.gfeeds.saved_articles
allow  /usr/libexec/webkit2gtk-4.0
allow  /usr/share/gfeeds
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
noinput
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
