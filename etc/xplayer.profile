# Firejail profile for xplayer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xplayer.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/xplayer
noblacklist ${HOME}/.local/share/xplayer
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
netfilter
# nodbus - makes settings immutable
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin xplayer,xplayer-audio-preview,xplayer-video-thumbnailer
private-dev
# private-etc fonts,machine-id,pulse,asound.conf,ca-certificates,ssl,pki,crypto-policies
private-tmp

noexec ${HOME}
noexec /tmp
