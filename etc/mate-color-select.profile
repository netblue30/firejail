# Firejail profile for mate-color-select
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mate-color-select.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.config/gtk-3.0
whitelist ${HOME}/.fonts
whitelist ${HOME}/.icons
whitelist ${HOME}/.themes

caps.drop all
netfilter
no3d
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
private-bin mate-color-select
private-etc fonts
private-dev
private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
