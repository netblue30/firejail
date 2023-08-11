# Firejail profile for gapplication
# Description: D-Bus application launcher
# This file is overwritten after every install/update
# Persistent local customizations
include gapplication.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

#include whitelist-common.inc # see #903
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
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
protocol unix
seccomp
seccomp.block-secondary
tracelog
x11 none

disable-mnt
private
private-bin gapplication
private-cache
private-dev
private-etc
private-tmp

# Add the next line to your gapplication.local to filter D-Bus names.
# You might need to add additional dbus-user.talk rules (see 'gapplication list-apps').
#dbus-user filter
dbus-user.talk org.gnome.Boxes
dbus-user.talk org.gnome.Builder
dbus-user.talk org.gnome.Calendar
dbus-user.talk org.gnome.ChromeGnomeShell
dbus-user.talk org.gnome.DejaDup
dbus-user.talk org.gnome.DiskUtility
dbus-user.talk org.gnome.Extensions
dbus-user.talk org.gnome.Maps
dbus-user.talk org.gnome.Nautilus
dbus-user.talk org.gnome.Shell.PortalHelper
dbus-user.talk org.gnome.Software
dbus-user.talk org.gnome.Weather
dbus-system none

memory-deny-write-execute
read-only ${HOME}
restrict-namespaces
