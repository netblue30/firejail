# Firejail profile for flameshot
# Description: Powerful yet simple-to-use screenshot software
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include flameshot.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}
noblacklist ${HOME}/.config/Dharkael
noblacklist ${HOME}/.config/flameshot

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

#mkdir ${HOME}/.config/Dharkael
#mkdir ${HOME}/.config/flameshot
#whitelist ${PICTURES}
#whitelist ${HOME}/.config/Dharkael
#whitelist ${HOME}/.config/flameshot
whitelist /usr/share/flameshot
#include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
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
private-bin flameshot
private-cache
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.conf,machine-id,pki,resolv.conf,ssl
private-dev
#private-tmp

dbus-user filter
dbus-user.own org.dharkael.Flameshot
dbus-user.own org.flameshot.Flameshot
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.portal.Desktop
dbus-user.talk org.gnome.Shell
dbus-user.talk org.kde.KWin
dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.own org.kde.*
dbus-system none
