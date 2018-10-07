# Firejail profile for bless
# Description: A full featured hexadecimal editor
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/bless.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/bless

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

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

# private-bin bless,sh,bash,mono
private-cache
private-dev
private-etc fonts,mono
private-tmp

noexec ${HOME}
noexec /tmp
