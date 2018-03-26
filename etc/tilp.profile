# Firejail profile for tilp
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/tilp.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.tilp

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin tilp
private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
