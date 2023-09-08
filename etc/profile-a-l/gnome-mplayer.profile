# Firejail profile for gnome-mplayer
# Description: GTK/Gnome interface around MPlayer
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-mplayer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gnome-mplayer
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
nogroups
noinput
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp

#private-bin gnome-mplayer,mplayer
private-cache
private-dev
private-tmp

restrict-namespaces
