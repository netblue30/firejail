# Firejail profile for glaxium
# Description: 3d spaceship shoot-em-up
# This file is overwritten after every install/update
# Persistent local customizations
include glaxium.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.glaxiumrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkfile ${HOME}/.glaxiumrc
whitelist ${HOME}/.glaxiumrc
whitelist /usr/share/glaxium
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
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
private-bin glaxium
private-cache
private-dev
private-etc @x11,bumblebee,glvnd
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
