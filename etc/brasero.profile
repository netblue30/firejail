# Firejail profile for brasero
# Description: CD/DVD burning application for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/brasero.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/brasero

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin brasero
private-cache
# private-dev
# private-etc fonts
# private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
