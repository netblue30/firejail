# Firejail profile for neochat
# Description: Matrix Client
# This file is overwritten after every install/update
# Persistent local customizations
include neochat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/KDE/neochat
noblacklist ${HOME}/.config/KDE/neochat
noblacklist ${HOME}/.config/neochatrc
noblacklist ${HOME}/.config/neochat.notifyrc
noblacklist ${HOME}/.local/share/KDE/neochat
noblacklist ${DOWNLOADS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/KDE/neochat
mkdir ${HOME}/.config/KDE/neochat.conf
mkdir ${HOME}/.local/share/KDE/neochat
mkfile ${HOME}/.config/neochatrc
mkfile ${HOME}/.config/neochat.notifyrc

whitelist ${HOME}/.cache/KDE/neochat
whitelist ${HOME}/.config/KDE/neochat.conf
whitelist ${HOME}/.config/neochatrc
whitelist ${HOME}/.local/share/KDE/neochat
whitelist ${HOME}/.config/neochat.notifyrc
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
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin neochat
private-dev
##private-etc Common,Networking,GUI,Qt,KDE,D-Bus
private-etc alternatives,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mime.types,xdg,ca-certificates,ssl,pki,crypto-policies,nsswitch.conf,resolv.conf,hosts,host.conf,hostname,protocols,services,rpc,fonts,pango,X11,Trolltech.conf,kde4rc,kde5rc,dbus-1,machine-id
##private-lib LIBS
##private-opt NAME
private-tmp

## dbus-user permissions copied from the flatpak package
dbus-user filter
dbus-user.own org.kde.neochat
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk com.canonical.AppMenu.Registrar
dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.talk org.kde.kwalletd5
dbus-system none

join-or-start neochat
