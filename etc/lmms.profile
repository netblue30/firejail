# Firejail profile for lmms
# Description: Linux Multimedia Studio
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/lmms.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.lmmsrc.xml
noblacklist ${DOCUMENTS}
noblacklist ${MUSIC}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
ipc-namespace
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
