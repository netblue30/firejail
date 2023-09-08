# Firejail profile for mplayer
# Description: mplayer KDE GUI (movie player)
# This file is overwritten after every install/update
# Persistent local customizations
include kmplayer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/kmplayerrc
noblacklist ${HOME}/.kde/share/config/kmplayerrc
noblacklist ${HOME}/.local/share/kmplayer
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp

#private-bin kmplayer,mplayer
private-cache
private-dev
private-tmp

restrict-namespaces
