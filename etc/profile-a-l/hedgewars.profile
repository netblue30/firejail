# Firejail profile for hedgewars
# Description: Funny turn-based artillery game, featuring fighting hedgehogs
# This file is overwritten after every install/update
# Persistent local customizations
include hedgewars.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.hedgewars

include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.hedgewars
whitelist ${HOME}/.hedgewars
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
seccomp
tracelog

disable-mnt
private-dev
private-tmp
