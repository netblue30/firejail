# Firejail profile for smtube
# Description: YouTube videos browser
# This file is overwritten after every install/update
# Persistent local customizations
include smtube.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mpv
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/smplayer
noblacklist ${HOME}/.config/smtube
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.local/share/vlc
noblacklist ${HOME}/.local/state/mpv
noblacklist ${HOME}/.mplayer
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/smplayer
whitelist /usr/share/smtube
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
notv
nou2f
novideo
nogroups
noinput
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp

#no private-bin because users can add their own players to smtube and that would prevent that
private-dev
private-tmp

restrict-namespaces
