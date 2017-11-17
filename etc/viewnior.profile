# Firejail profile for viewnior
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/viewnior.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus
blacklist ${HOME}/.Xauthority
blacklist ${HOME}/.bashrc

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.config/viewnior
noblacklist ${HOME}/.steam

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
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

private-bin viewnior
private-dev
private-etc fonts
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
