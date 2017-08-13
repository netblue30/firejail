# Firejail profile for evince
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/evince.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/evince

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
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
protocol unix
seccomp
shell none
tracelog

private-bin evince,evince-previewer,evince-thumbnailer
private-dev
private-etc fonts
# evince needs access to /tmp/mozilla* to work in firefox
# private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
