# Firejail profile for zeal
# Description: Offline API documentation browser
# This file is overwritten after every install/update
# Persistent local customizations
include zeal.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Zeal
noblacklist ${HOME}/.config/Zeal
noblacklist ${HOME}/.local/share/Zeal

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# Allow zeal to open links in Firefox.
# This also requires dbus-user filtering (see below).
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini
read-only ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.cache/Zeal
mkdir ${HOME}/.config/Zeal
mkdir ${HOME}/.local/share/Zeal
whitelist ${HOME}/.cache/Zeal
whitelist ${HOME}/.config/Zeal
whitelist ${HOME}/.local/share/Zeal
include whitelist-common.inc
include whitelist-run-common.inc
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
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin zeal
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,pki,protocols,resolv.conf,rpc,services,ssl,Trolltech.conf,X11,xdg
private-tmp

dbus-user filter
dbus-user.talk org.mozilla.Firefox.*
dbus-user.talk org.mozilla.firefox.*
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-system none

# memory-deny-write-execute - breaks on Arch
