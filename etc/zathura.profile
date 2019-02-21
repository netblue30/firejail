# Firejail profile for zathura
# Description: Document viewer with a minimalistic interface
# This file is overwritten after every install/update
# Persistent local customizations
include zathura.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/zathura
noblacklist ${HOME}/.local/share/zathura
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
machine-id
# net none
# nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
protocol unix
seccomp
shell none

private-bin zathura
private-cache
private-dev
private-etc alternatives,fonts,machine-id
private-tmp

read-only ${HOME}/
read-write ${HOME}/.local/share/zathura/
