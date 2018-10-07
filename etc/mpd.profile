# Firejail profile for mpd
# Description: Music Player Daemon
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mpd.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/mpd
noblacklist ${HOME}/.mpd
noblacklist ${HOME}/.mpdconf
noblacklist ${MUSIC}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

#private-bin mpd,bash
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
