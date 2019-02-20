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
#include disable-interpreters.inc
include disable-passwdmgr.inc
#include disable-programs.inc

caps.drop all
ipc-namespace
# machine-id breaks audio; it should work fine in setups where sound is not required
machine-id
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-cache
private-dev
private-etc alternatives,fonts
private-lib gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libgconf-2.so.*,librsvg-2.so.*
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
