# Firejail profile for xplayer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xplayer.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/xplayer
noblacklist ~/.local/share/xplayer

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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
# private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
