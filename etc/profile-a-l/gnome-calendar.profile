# Firejail profile for gnome-calendar
# Description: Calendar for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-calendar.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/libgweather
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
shell none
tracelog

disable-mnt
private
private-bin gnome-calendar
private-cache
private-dev
private-etc ca-certificates,crypto-policies,dconf,fonts,gtk-3.0,nsswitch.conf,pki,resolv.conf,ssl
private-tmp

dbus-user filter
dbus-user.own org.gnome.Calendar
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.gnome.evolution.dataserver.*
#dbus-user.talk org.gnome.OnlineAccounts
#dbus-user.talk org.gnome.ControlCenter
# NOTE: dbus-system none fails, filter without rules works.
dbus-system filter
#dbus-system.talk org.freedesktop.timedate1
#dbus-system.talk org.freedesktop.login1
#dbus-system.talk org.freedesktop.GeoClue2

read-only ${HOME}
