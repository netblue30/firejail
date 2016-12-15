# Xreader profile
noblacklist ~/.config/xreader
noblacklist ~/.cache/xreader
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

private-bin xreader, xreader-previewer, xreader-thumbnailer
private-dev
private-tmp
