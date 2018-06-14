# Firejail profile for gnome-mpv
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-mpv.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/gnome-mpv

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
nodbus
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

private-bin gnome-mpv
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
