# Firejail profile for nheko
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/nheko.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/nheko
noblacklist ${HOME}/.cache/nheko/nheko

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/nheko
mkdir ${HOME}/.cache/nheko/nheko

whitelist ${HOME}/.config/nheko
whitelist ${HOME}/.cache/nheko/nheko
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
tracelog

disable-mnt
private-bin nheko
private-tmp

noexec ${HOME}
noexec /tmp
