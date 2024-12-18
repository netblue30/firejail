# Firejail profile for crawl-tiles
# Description: Roguelike dungeon exploration game
# This file is overwritten after every install/update
# Persistent local customizations
include crawl-tiles.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.crawl

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.crawl
whitelist ${HOME}/.crawl
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp

disable-mnt
private-bin crawl,crawl-tiles
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
