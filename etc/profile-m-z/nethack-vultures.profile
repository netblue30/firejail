# Firejail profile for nethack-vultures
# Description: A rogue-like single player dungeon exploration game
# This file is overwritten after every install/update
# Persistent local customizations
include nethack.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.vultures

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.vultures
whitelist ${HOME}/.vultures
whitelist /var/log/vultures
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
#nonewprivs
#noroot
notv
novideo
#protocol unix,netlink
#seccomp

disable-mnt
#private
private-cache
private-dev
private-tmp
writable-var

dbus-user none
dbus-system none

#restrict-namespaces
