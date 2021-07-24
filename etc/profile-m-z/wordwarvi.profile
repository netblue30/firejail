# Firejail profile for wordwarvi
# Description: Old school '80's style side scrolling space shoot'em up game.
# This file is overwritten after every install/update
# Persistent local customizations
include wordwarvi.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.wordwarvi

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.wordwarvi
allow  ${HOME}/.wordwarvi
allow  /usr/share/wordwarvi
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private
private-bin wordwarvi
private-cache
private-dev
private-etc alsa,asound.conf,machine-id,pulse
private-tmp

dbus-user none
dbus-system none
