# Firejail profile for nheko
# Description: Desktop IM client for the Matrix protocol
# This file is overwritten after every install/update
# Persistent local customizations
include nheko.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/nheko
nodeny  ${HOME}/.config/nheko
nodeny  ${HOME}/.local/share/nheko

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/nheko
mkdir ${HOME}/.config/nheko
mkdir ${HOME}/.local/share/nheko
allow  ${HOME}/.cache/nheko
allow  ${HOME}/.config/nheko
allow  ${HOME}/.local/share/nheko
allow  ${DOWNLOADS}
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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin nheko
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,mime.types,nsswitch.conf,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-tmp


# Add the next lines to your nheko.local to enable notification support.
#ignore dbus-user none
#dbus-user filter
#dbus-user.talk org.freedesktop.Notifications
#dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user none
dbus-system none
