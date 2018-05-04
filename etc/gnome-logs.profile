# Firejail profile for gnome-logs
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-logs.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist /var/log/journal
include /etc/firejail/whitelist-var-common.inc

caps.drop all
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin gnome-logs
private-dev
private-etc fonts,localtime
private-lib gdk-pixbuf-2.0,gio,gvfs/libgvfscommon.so,libgconf-2.so.4,librsvg-2.so.2
private-tmp
writable-var-log

noexec ${HOME}
noexec /tmp
