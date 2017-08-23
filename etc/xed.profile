# Firejail profile for xed
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xed.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/xed

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
# net none - makes settings immutable
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

private-bin xed
private-dev
# private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
