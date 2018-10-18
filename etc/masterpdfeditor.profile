# Firejail profile for masterpdfeditor
# Description: A complete solution for creating and editing PDF files
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/masterpdfeditor.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Code Industry
noblacklist ${HOME}/.masterpdfeditor

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
machine-id
net none
no3d
nodbus
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
tracelog

# disable-mnt
# private
private-bin masterpdfeditor*
private-cache
private-dev
private-etc fonts
# private-lib
private-tmp

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
