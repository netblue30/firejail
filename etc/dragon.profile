# Firejail profile for dragon
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dragon.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/dragonplayerrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin dragon
private-dev
# private-etc
private-tmp

noexec ${HOME}
noexec /tmp
