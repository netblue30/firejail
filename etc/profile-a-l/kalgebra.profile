# Firejail profile for kalgebra
# Description: 2D and 3D Graph Calculator
# This file is overwritten after every install/update
# Persistent local customizations
include kalgebra.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/kalgebrarc
noblacklist ${HOME}/.local/share/kalgebra

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/kalgebramobile
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,netlink
seccomp !chroot
#tracelog

disable-mnt
private-bin kalgebra,kalgebramobile
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
