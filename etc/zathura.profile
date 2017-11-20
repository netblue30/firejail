# Firejail profile for zathura
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/zathura.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus

noblacklist ${HOME}/.config/zathura
noblacklist ${HOME}/.local/share/zathura

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
# net none
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix
seccomp
shell none

private-bin zathura
private-dev
private-etc fonts
private-tmp
read-only ${HOME}/
read-write ${HOME}/.local/share/zathura/
