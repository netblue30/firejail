# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gnome-chess.local

# Firejail profile for gnome-chess
noblacklist ~/.local/share/gnome-chess

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
no3d
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix
seccomp
shell none
tracelog

private-bin fairymax,gnome-chess,hoichess
private-dev
private-etc fonts,gnome-chess
private-tmp
disable-mnt

noexec ${HOME}
noexec /tmp
