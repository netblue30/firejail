# Firejail profile for gnome-mpv
# Description: Simple GTK+ frontend for mpv
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-mpv.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gnome-mpv
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
nodbus
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp
shell none

private-bin gnome-mpv,youtube-dl,python*,env
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
