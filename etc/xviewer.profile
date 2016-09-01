noblacklist ~/.config/xviewer

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
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

private-dev
private-bin xviewer
private-tmp
