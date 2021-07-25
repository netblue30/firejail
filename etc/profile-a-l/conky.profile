# Firejail profile for conky
# Description: Highly configurable system monitor
# This file is overwritten after every install/update
# Persistent local customizations
include conky.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
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
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-cache
private-dev
private-tmp

memory-deny-write-execute
