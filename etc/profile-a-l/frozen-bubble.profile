# Firejail profile for frozen-bubble
# Description: Cool game where you pop out the bubbles
# This file is overwritten after every install/update
# Persistent local customizations
include frozen-bubble.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.frozen-bubble

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.frozen-bubble
whitelist ${HOME}/.frozen-bubble
include whitelist-common.inc
include whitelist-runuser-common.inc
whitelist /usr/share/games
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
protocol unix,netlink
seccomp
tracelog

disable-mnt
#private-bin frozen-bubble
private-dev
private-etc @games,@x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
