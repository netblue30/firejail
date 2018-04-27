# Firejail profile for XMind
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/XMind.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.xmind

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.xmind
whitelist ${HOME}/.xmind
whitelist ${DOWNLOADS}
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
private-bin XMind,sh,cp
private-tmp
private-dev

noexec ${HOME}
noexec /tmp
