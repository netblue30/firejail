# Firejail profile for knotes
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/knotes.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/knotesrc

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

# private-bin kate
private-dev
# private-etc fonts
private-tmp
notv
