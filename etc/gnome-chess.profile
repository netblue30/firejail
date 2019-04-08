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

include whitelist-var-common.inc

caps.drop all
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
private-dev
private-etc alternatives,fonts,gnome-chess
private-tmp
