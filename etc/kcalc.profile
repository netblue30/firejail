# Firejail profile for kcalc
# Description: Simple and scientific calculator
# This file is overwritten after every install/update
# Persistent local customizations
include kcalc.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkfile ${HOME}/.config/kcalcrc
mkfile ${HOME}/.kde/share/config/kcalcrc
mkfile ${HOME}/.kde4/share/config/kcalcrc
whitelist ${HOME}/.config/kcalcrc
whitelist ${HOME}/.kde/share/config/kcalcrc
whitelist ${HOME}/.kde4/share/config/kcalcrc
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
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
private-bin kcalc
private-dev
# private-lib - problems on Arch
private-tmp

dbus-user none
dbus-system none
