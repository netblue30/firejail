# Firejail profile for gnome-pie
# Description: Alternative AppMenu
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-pie.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gnome-pie

#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
#include disable-interpreters.inc
#include disable-programs.inc

caps.drop all
ipc-namespace
#net none # breaks dbus
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

disable-mnt
private-cache
private-dev
private-etc
private-lib gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libgconf-2.so.*,librsvg-2.so.*
private-tmp

memory-deny-write-execute
restrict-namespaces
