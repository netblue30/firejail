# Firejail profile for widelands
# Description: Open source realtime-strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include widelands.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.widelands

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.widelands
whitelist ${HOME}/.widelands
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin widelands
private-cache
private-dev
private-tmp
