# Firejail profile for mate-color-select
# This file is overwritten after every install/update
# Persistent local customizations
include mate-color-select.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

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
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin mate-color-select
private-etc alternatives,fonts
private-dev
private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
