# GNOME MPlayer profile
noblacklist /mnt
noblacklist /media
noblackist /run/media

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

private-bin gnome-mplayer,mplayer
private-dev
private-tmp
