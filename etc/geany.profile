# Firejail profile for geany
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/geany.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/geany

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp
