# Firejail profile for xfburn
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xfburn.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/xfburn

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin xfburn
# private-dev
# private-etc fonts
# private-tmp
