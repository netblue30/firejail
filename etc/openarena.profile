# Firejail profile for OpenArena
# Description: deathmatch FPS game based on GPL idTech3 technology
# This file is overwritten after every install/update
# Persistent local customizations
include openarena.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.openarena

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
# ipc-namespace
# machine-id
# net none
# netfilter
# no3d
# nodbus
# nodvd
# nogroups
nonewprivs
noroot
# nosound
notv
# nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
# tracelog

# disable-mnt
# private
# private-bin openarena
private-cache
private-dev
# private-etc machine-id,xdg,openal,udev,drirc,passwd,selinux
# private-lib
private-tmp

# memory-deny-write-execute
