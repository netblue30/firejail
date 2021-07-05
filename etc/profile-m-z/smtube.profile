# Firejail profile for smtube
# Description: YouTube videos browser
# This file is overwritten after every install/update
# Persistent local customizations
include smtube.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/smplayer
nodeny  ${HOME}/.config/smtube
nodeny  ${HOME}/.config/mpv
nodeny  ${HOME}/.mplayer
nodeny  ${HOME}/.config/vlc
nodeny  ${HOME}/.local/share/vlc
nodeny  ${MUSIC}
nodeny  ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

allow  /usr/share/smplayer
allow  /usr/share/smtube
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
shell none

#no private-bin because users can add their own players to smtube and that would prevent that
private-dev
private-tmp

