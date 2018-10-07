# Firejail profile for asounder
# Description: Graphical audio CD ripper and encoder
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/asunder.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/asunder
noblacklist ${HOME}/.asunder_album_genre
noblacklist ${HOME}/.asunder_album_title
noblacklist ${HOME}/.asunder_album_artist
noblacklist ${MUSIC}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodbus
# nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

#private-bin vlc,cvlc,nvlc,rvlc,qvlc,svlc
private-dev
private-tmp

# mdwe is disabled due to breaking hardware accelerated decoding
# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
