# Firejail profile for vym
# Description: Mindmapping tool
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/vym.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/InSilmaril

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
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

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
