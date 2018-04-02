# Firejail profile for keepassxc
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/keepassxc.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.config/keepassxc
noblacklist ${HOME}/.keepassxc
# 2.2.4 needs this path when compiled with "Native messaging browser extension"
noblacklist ${HOME}/.mozilla

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
net none
no3d
nodvd
nodbus
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

# 2.2.4 crashes on database open
#memory-deny-write-execute
noexec ${HOME}
noexec /tmp
