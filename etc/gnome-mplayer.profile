# Firejail profile for gnome-mplayer
# Description: GTK/Gnome interface around MPlayer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-mplayer.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/gnome-mplayer
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

# private-bin gnome-mplayer,mplayer
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
