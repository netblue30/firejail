# Firejail profile for mate-calc
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mate-calc.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/mate-calc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.cache/mate-calc
whitelist ${HOME}/.config/caja
whitelist ${HOME}/.config/gtk-3.0
whitelist ${HOME}/.config/dconf
whitelist ${HOME}/.config/mate-menu
whitelist ${HOME}/.themes

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
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin mate-calc,mate-calculator
private-etc fonts
private-dev
private-opt none
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
