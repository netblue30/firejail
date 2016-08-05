# Firejail profile for gnome-chess
noblacklist /.local/share/gnome-chess

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
net none
nogroups
nonewprivs
noroot
nosound
seccomp
shell none
tracelog

private-bin gnome-chess
private-dev
