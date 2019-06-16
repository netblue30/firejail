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
# netfilter
# nodbus
# nodvd
# nogroups
nonewprivs
noroot
notv
# nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
# tracelog

# disable-mnt
# private-bin openarena
private-cache
private-dev
# private-etc drirc,machine-id,openal,passwd,selinux,udev,xdg
private-tmp
