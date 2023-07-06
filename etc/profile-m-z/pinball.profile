# Firejail profile for pinball
# Description: Emilia 3D Pinball Game
# This file is overwritten after every install/update
# Persistent local customizations
include pinball.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/emilia

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/emilia
whitelist ${HOME}/.config/emilia

whitelist /usr/share/pinball
# on debian games are stored under /usr/share/games
whitelist /usr/share/games/pinball
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
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
seccomp.block-secondary
tracelog

disable-mnt
private-bin pinball
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
