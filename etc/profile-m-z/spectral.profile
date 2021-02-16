# Firejail profile for spectral
# Description: Desktop client for Matrix
# This file is overwritten after every install/update
# Persistent local customizations
include spectral.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/ENCOM/Spectral
noblacklist ${HOME}/.config/ENCOM

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/ENCOM/Spectral
mkdir ${HOME}/.config/ENCOM
whitelist ${HOME}/.cache/ENCOM/Spectral
whitelist ${HOME}/.config/ENCOM
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-cache
private-bin spectral
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,mime.types,nsswitch.conf,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.secrets
# Uncomment the lines below for native notification and tray icons
# dbus-user.talk org.freedesktop.Notifications
# dbus-user.talk org.kde.StatusNotifierWatcher
dbus-system none
