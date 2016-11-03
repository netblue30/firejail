# Atril profile
noblacklist ~/.config/atril
noblacklist ~/.local/share
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

private-bin atril, atril-previewer, atril-thumbnailer
private-dev
private-tmp
