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
include allow-python2.inc
include allow-python3.inc

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

private-bin env,gio-launch-desktop,gnome-music,python*,yelp
private-dev
private-etc alternatives,asound.conf,fonts,machine-id,pulse
private-tmp

