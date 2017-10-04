# Firejail profile for gnome-clocks
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-clocks.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
# private-bin gnome-clocks
private-dev
# private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
