# Firejail profile for gpredict
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gpredict.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Gpredict

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.config/Gpredict
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin gpredict
private-dev
private-etc fonts,resolv.conf
private-tmp

noexec ${HOME}
noexec /tmp
