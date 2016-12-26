# Rhythmbox media player profile
noblacklist /mnt
noblacklist /media
noblackist /run/media

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin rhythmbox
private-dev
private-tmp
