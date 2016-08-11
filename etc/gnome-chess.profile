# Firejail profile for gnome-chess
noblacklist /.local/share/gnome-chess

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

private-bin fairymax,gnome-chess,hoichess
private-dev
private-etc fonts,gnome-chess
private-tmp
