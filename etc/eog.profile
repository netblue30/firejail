# Firejail profile for eog
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/eog.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.config/eog
noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.steam

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
# net none - makes settings immutable
no3d
# nodbus - makes settings immutable
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

private-bin eog
private-dev
private-etc fonts
private-lib gdk-pixbuf-2.0,gio,girepository-1.0,gvfs,libgconf-2.so.4
private-tmp

#memory-deny-write-execute  - breaks on Arch
noexec ${HOME}
noexec /tmp
