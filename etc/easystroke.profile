# Firejail profile for easystroke
# Description: Control your desktop using mouse gestures
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/easystroke.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.easystroke

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
machine-id
net none
no3d
# nodbus
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
private-bin easystroke
private-cache
private-dev
private-etc fonts
private-lib gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libgconf-2.so.*,librsvg-2.so.*
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
