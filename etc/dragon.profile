# Firejail profile for dragon
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dragon.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/dragonplayerrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin dragon
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
