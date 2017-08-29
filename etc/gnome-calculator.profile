# Firejail profile for gnome-calculator
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-calculator.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private
private-bin gnome-calculator
private-dev
# private-etc fonts
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
