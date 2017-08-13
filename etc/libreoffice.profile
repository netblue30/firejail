# Firejail profile for libreoffice
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/libreoffice.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.java
noblacklist /usr/local/sbin
noblacklist ~/.config/libreoffice

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
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-dev

noexec ${HOME}
noexec /tmp
