# Firejail profile for Cryptocat
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/Cryptocat.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Cryptocat

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
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
protocol unix,inet,inet6,netlink
seccomp
shell none

private-cache
private-dev
private-tmp
