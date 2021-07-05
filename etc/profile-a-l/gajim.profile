# Firejail profile for gajim
# Description: GTK+-based Jabber client
# This file is overwritten after every install/update
# Persistent local customizations
include gajim.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.gnupg
nodeny  ${HOME}/.cache/gajim
nodeny  ${HOME}/.config/gajim
nodeny  ${HOME}/.local/share/gajim

# Allow python (blacklisted by disable-interpreters.inc)
#include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
# Add 'ignore include disable-xdg.inc' to your gajim.local if you need to whitelist folders other than ~/Downloads.
include disable-xdg.inc

mkdir ${HOME}/.gnupg
mkdir ${HOME}/.cache/gajim
mkdir ${HOME}/.config/gajim
mkdir ${HOME}/.local/share/gajim
allow  ${HOME}/.gnupg
allow  ${HOME}/.cache/gajim
allow  ${HOME}/.config/gajim
allow  ${HOME}/.local/share/gajim
allow  ${DOWNLOADS}
allow  ${RUNUSER}/gnupg
allow  /usr/share/gnupg
allow  /usr/share/gnupg2
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin bash,gajim,gajim-history-manager,gpg,gpg2,paplay,python*,sh,zsh
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,group,hostname,hosts,ld.so.cache,ld.so.conf,localtime,machine-id,passwd,pki,pulse,resolv.conf,ssl,xdg
private-tmp
writable-run-user

dbus-user filter
dbus-user.own org.gajim.Gajim
dbus-user.talk org.gnome.Mutter.IdleMonitor
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.kde.kwalletd5
dbus-user.talk org.mpris.MediaPlayer2.*
dbus-system filter
dbus-system.talk org.freedesktop.login1
# Add the next line to your gajim.local to enable location plugin support.
#dbus-system.talk org.freedesktop.GeoClue2

join-or-start gajim
