# Firejail profile for gnome-chess
# Description: Simple chess game
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-chess.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gnome-chess
noblacklist ${HOME}/.local/share/gnome-chess

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

#mkdir ${HOME}/.local/share/gnome-chess
#whitelist ${HOME}/.local/share/gnome-chess
#include whitelist-common.inc

whitelist /usr/share/gnuchess
whitelist /usr/share/gnome-chess
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog

disable-mnt
private-bin fairymax,gnome-chess,gnuchess,hoichess
private-cache
private-dev
private-etc alternatives,dconf,fonts,gnome-chess,gtk-3.0,ld.so.cache,ld.so.preload
private-tmp
