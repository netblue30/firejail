# Firejail profile for mediathekview
# Description: View streams from German public television stations
# This file is overwritten after every install/update
# Persistent local customizations
include mediathekview.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/mpv
nodeny  ${HOME}/.config/smplayer
nodeny  ${HOME}/.config/totem
nodeny  ${HOME}/.config/vlc
nodeny  ${HOME}/.config/xplayer
nodeny  ${HOME}/.local/share/totem
nodeny  ${HOME}/.local/share/xplayer
nodeny  ${HOME}/.mediathek3
nodeny  ${HOME}/.mplayer
nodeny  ${VIDEOS}

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

private-cache
private-dev
private-tmp

