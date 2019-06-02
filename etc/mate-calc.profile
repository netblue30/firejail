# Firejail profile for mate-calc
# Description: MATE desktop calculator
# This file is overwritten after every install/update
# Persistent local customizations
include mate-calc.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mate-calc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/mate-calc
mkdir ${HOME}/.config/caja
mkdir ${HOME}/.config/mate-menu
whitelist ${HOME}/.cache/mate-calc
whitelist ${HOME}/.config/caja
whitelist ${HOME}/.config/mate-menu
include whitelist-common.inc

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
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin mate-calc,mate-calculator
private-etc alternatives,dconf,fonts,gtk-3.0
private-dev
private-opt none
private-tmp

memory-deny-write-execute
