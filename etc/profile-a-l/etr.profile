# Firejail profile for etr
# Description: High speed arctic racing game
# This file is overwritten after every install/update
# Persistent local customizations
include etr.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.etr

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.etr
whitelist ${HOME}/.etr
whitelist /usr/share/etr
# Debian version
whitelist /usr/share/games/etr
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
protocol unix,netlink
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin etr
private-cache
private-dev
#private-etc alternatives,drirc,machine-id,openal,passwd
private-etc @games,@x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
