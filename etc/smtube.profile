# Firejail profile for smtube
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/smtube.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/smplayer
noblacklist ${HOME}/.config/smtube
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.mplayer
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.local/share/vlc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
notv
novideo
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

#no private-bin because users can add their own players to smtube and that would prevent that
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
