# Firejail profile for open-invaders
# Description: Space Invaders clone
# This file is overwritten after every install/update
# Persistent local customizations
include open-invaders.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.openinvaders

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.openinvaders
whitelist ${HOME}/.openinvaders
include whitelist-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,netlink
seccomp
shell none

# private-bin open-invaders
private-dev
# private-etc alternatives
private-tmp
