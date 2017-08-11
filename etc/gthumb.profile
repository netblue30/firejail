# Firejail profile for gthumb
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gthumb.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/gthumb
noblacklist ~/.Steam
noblacklist ~/.steam

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

private-bin gthumb
private-dev
private-tmp
notv
