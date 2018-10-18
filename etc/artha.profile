# Firejail profile for artha
# Description: A free cross-platform English thesaurus based on WordNet
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/artha.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/artha.conf
noblacklist ${HOME}/.config/enchant

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
machine-id
net none
no3d
# nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin artha,enchant,notify-send
private-cache
private-dev
private-etc fonts
private-lib libnotify.so.*
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
