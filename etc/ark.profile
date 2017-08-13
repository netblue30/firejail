# Firejail profile for ark
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ark.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/arkrc

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
novideo
protocol unix
seccomp
shell none

# private-bin
private-dev
# private-etc
private-tmp
