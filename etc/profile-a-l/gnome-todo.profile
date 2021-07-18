# Firejail profile for gnome-todo
# Description: Personal task manager for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-todo.local
# Persistent global definitions
include globals.local

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

whitelist /usr/share/gnome-todo
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
#private
private-bin gnome-todo
private-cache
private-dev
private-etc dconf,fonts,gtk-3.0,localtime,passwd,xdg
private-tmp

dbus-user filter
dbus-user.own org.gnome.Todo
dbus-user.talk ca.desrt.dconf
#dbus-user.talk org.gnome.evolution.dataserver.AddressBook9
dbus-user.talk org.gnome.evolution.dataserver.Calendar8
dbus-user.talk org.gnome.evolution.dataserver.Sources5
#dbus-user.talk org.gnome.evolution.dataserver.Subprocess.Backend.*
#dbus-user.talk org.gnome.OnlineAccounts
dbus-system none
#dbus-system filter
#dbus-system.talk org.freedesktop.login1

read-only ${HOME}
