# Firejail profile for atom-beta
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/atom-beta.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.atom
noblacklist ~/.config/Atom

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp
