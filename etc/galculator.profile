# Firejail profile for galculator
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/galculator.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/galculator

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.config/galculator
whitelist ~/.config/galculator
include /etc/firejail/whitelist-common.inc

caps.drop all
net none
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

private-bin galculator
private-dev
private-etc fonts
private-tmp
