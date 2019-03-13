# Firejail profile for gnome-music
# Description: GNOME music player
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-music.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/gnome-music
noblacklist ${MUSIC}

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
netfilter
no3d
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin gnome-music,python*,env,gio-launch-desktop,yelp
private-dev
private-etc alternatives,fonts,machine-id,pulse,asound.conf
private-tmp

noexec ${HOME}
noexec /tmp
