# Firejail profile for gnome-mplayer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-mplayer.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/gnome-mplayer

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

# private-bin gnome-mplayer,mplayer
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
