# Firejail profile for smtube
# Description: YouTube videos browser
# This file is overwritten after every install/update
# Persistent local customizations
include smtube.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/smplayer
noblacklist ${HOME}/.config/smtube
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.mplayer
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.local/share/vlc
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/smplayer
whitelist /usr/share/smtube
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
notv
nou2f
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

