# Firejail profile for gnome-builder
# Description: IDE for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-builder.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-cache
private-dev
