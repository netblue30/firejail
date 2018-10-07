# Firejail profile for gpicview
# Description: Lightweight image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gpicview.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/gpicview

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
net none
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
tracelog

private-bin gpicview
private-dev
private-etc fonts
private-lib
private-tmp
