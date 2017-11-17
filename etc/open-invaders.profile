# Firejail profile for open-invaders
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/open-invaders.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

noblacklist ${HOME}/.openinvaders

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.openinvaders
whitelist ${HOME}/.openinvaders
include /etc/firejail/whitelist-common.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,netlink
seccomp
shell none

# private-bin open-invaders
private-dev
# private-etc none
private-tmp
