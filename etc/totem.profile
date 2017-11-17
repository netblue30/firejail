# Firejail profile for totem
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/totem.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/totem
noblacklist ${HOME}/.local/share/totem

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

private-bin totem
private-dev
# private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp
