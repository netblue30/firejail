# Firejail profile for file-roller
# Description: Archive manager for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include file-roller.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
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
tracelog

# private-bin file-roller
private-dev
# private-etc alternatives,fonts
# private-tmp

#memory-deny-write-execute  - breaks on Arch
noexec ${HOME}
noexec /tmp
