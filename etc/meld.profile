# Firejail profile for meld
# Description: Graphical tool to diff and merge files
# This file is overwritten after every install/update
# Persistent local customizations
include meld.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/meld

include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-programs.inc

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

private-bin meld,python*
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
