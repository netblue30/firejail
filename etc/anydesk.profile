# Firejail profile for AnyDesk
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/anydesk.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.anydesk

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-interpreters.inc

mkdir ${HOME}/.anydesk
whitelist ${HOME}/.anydesk
include /etc/firejail/whitelist-common.inc

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

disable-mnt
private-bin anydesk
private-dev
private-tmp
