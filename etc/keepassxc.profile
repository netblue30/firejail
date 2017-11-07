# Firejail profile for keepassxc
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/keepassxc.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.config/keepassxc
noblacklist ${HOME}/.keepassxc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

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

private-bin keepassxc
private-dev
private-etc fonts,ld.so.cache,machine-id
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
