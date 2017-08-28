# Firejail profile for atril
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/atril.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/atril
noblacklist ~/.local/share

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
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

private-bin atril, atril-previewer, atril-thumbnailer
private-dev
private-etc fonts,ld.so.cache
# atril needs access to /tmp/mozilla* to work in firefox
# private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
