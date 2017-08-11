# Firejail profile for gnome-music
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-music.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.local/share/gnome-music

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin gnome-music,python3
private-dev
# private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
