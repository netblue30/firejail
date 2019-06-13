# Firejail profile for tremulous
# Description: First Person Shooter game based on the Quake 3 engine
# This file is overwritten after every install/update
# Persistent local customizations
include tremulous.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.tremulous

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.tremulous
whitelist ${HOME}/.tremulous
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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin tremded,tremulous,tremulous-wrapper
private-cache
private-dev
private-tmp
