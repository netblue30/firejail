# Firejail profile for galculator
# Description: Scientific calculator
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/galculator.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/galculator

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/galculator
whitelist ${HOME}/.config/galculator
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

apparmor
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

private-bin galculator
private-dev
private-etc fonts
private-lib
private-tmp
