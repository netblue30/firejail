# Firejail profile for mate-calc
# Description: MATE desktop calculator
# This file is overwritten after every install/update
# Persistent local customizations
include mate-calc.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/mate-calc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/mate-calc
mkdir ${HOME}/.config/caja
mkdir ${HOME}/.config/mate-menu
allow  ${HOME}/.cache/mate-calc
allow  ${HOME}/.config/caja
allow  ${HOME}/.config/mate-menu
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
nodvd
nogroups
noinput
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

dbus-user none
dbus-system none

memory-deny-write-execute
