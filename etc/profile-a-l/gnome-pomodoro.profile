# Firejail profile for gnome-pomodoro
# Description: time management utility for GNOME based on the pomodoro technique
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-pomodoro.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.local/share/gnome-pomodoro

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/gnome-pomodoro
allow  ${HOME}/.local/share/gnome-pomodoro
allow  /usr/share/gnome-pomodoro
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin gnome-pomodoro
private-cache
private-dev
private-etc dconf,fonts,gtk-3.0,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,localtime,machine-id
private-tmp

dbus-user filter
dbus-user.own org.gnome.Pomodoro
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.gnome.Mutter.IdleMonitor
dbus-user.talk org.gnome.Shell
dbus-user.talk org.freedesktop.Notifications
dbus-system none

read-only ${HOME}
read-write ${HOME}/.local/share/gnome-pomodoro
