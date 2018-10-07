# Firejail profile for dia
# Description: Diagram editor
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dia.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.dia
noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
net none
no3d
nodbus
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
#private-bin dia
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
