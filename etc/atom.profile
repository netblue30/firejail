# Firejail profile for atom
# Description: A hackable text editor for the 21st Century
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/atom.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.atom
noblacklist ${HOME}/.config/Atom

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
# net none
netfilter
nodbus
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

private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
