# Firejail profile for mediathekview
# Description: View streams from German public television stations
# This file is overwritten after every install/update
# Persistent local customizations
include mediathekview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/smplayer
noblacklist ${HOME}/.config/totem
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.config/xplayer
noblacklist ${HOME}/.local/share/totem
noblacklist ${HOME}/.local/share/xplayer
noblacklist ${HOME}/.mediathek3
noblacklist ${HOME}/.mplayer
noblacklist ${VIDEOS}

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

