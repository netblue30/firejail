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
whitelist /usr/libexec/webkit2gtk-4.0
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
tracelog

disable-mnt
private-bin gfeeds,python3*
#private-cache # feeds are stored in ~/.cache
private-dev
private-etc @tls-ca,@x11,dbus-1,gconf,host.conf,mime.types,rpc,services
private-tmp

dbus-user filter
dbus-user.own org.gabmus.gfeeds
dbus-user.talk ca.desrt.dconf
dbus-system none

restrict-namespaces
