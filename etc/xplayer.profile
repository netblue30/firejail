# Xplayer profile
noblacklist ~/.config/xplayer
noblacklist ~/.local/share/xplayer

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

private-bin xplayer,xplayer-audio-preview,xplayer-video-thumbnailer
private-dev
private-tmp
