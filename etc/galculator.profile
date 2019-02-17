# Firejail profile for galculator
# Description: Scientific calculator
# This file is overwritten after every install/update
# Persistent local customizations
include galculator.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/galculator

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/galculator
whitelist ${HOME}/.config/galculator
include whitelist-common.inc
include whitelist-var-common.inc

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
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin galculator
private-dev
private-etc alternatives,fonts
private-lib
private-tmp
