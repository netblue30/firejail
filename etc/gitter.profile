# Firejail profile for gitter
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gitter.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/autostart
noblacklist ~/.config/Gitter

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
nosound
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin gitter
private-dev
private-tmp
