# Firejail profile for gnome-chess
# Description: Simple chess game
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-chess.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/gnome-chess

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/gnome-chess_saved_games
whitelist ${HOME}/gnome-chess_saved_games

mkdir ${HOME}/.local/share/gnome-chess
whitelist ${HOME}/.local/share/gnome-chess
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin fairymax,gnome-chess,hoichess,gnuchess
private-cache
private-dev
private-etc alternatives,dconf,fonts,gnome-chess,gtk-3.0
private-tmp
