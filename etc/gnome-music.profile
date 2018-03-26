# Firejail profile for gnome-music
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-music.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/gnome-music

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

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin gnome-music,python*
private-dev
# private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
