# Firejail profile for meld
# Description: Graphical tool to diff and merge files
# This file is overwritten after every install/update
# Persistent local customizations
include meld.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/meld
noblacklist ${PATH}/python*
noblacklist /usr/include/python*
noblacklist /usr/lib/python*
noblacklist /usr/local/lib/python*
noblacklist /usr/share/python*

include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
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
tracelog

private-bin meld,python*
private-cache
private-dev
# private-etc fonts,alternatives
private-tmp

noexec ${HOME}
noexec /tmp
