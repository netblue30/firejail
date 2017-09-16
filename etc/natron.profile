# Firejail profile for natron
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/natron.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.Natron
noblacklist ${HOME}/.cache/INRIA/Natron/
noblacklist ${HOME}/.config/INRIA/
noblacklist /opt/natron/

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

ipc-namespace
shell none

private-bin natron
#private-etc fonts,X11,pulse

noexec ${HOME}
noexec /tmp
