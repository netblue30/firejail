# Firejail profile for dconf-editor
# Description: dconf configuration editor
# This file is overwritten after every install/update
# Persistent local customizations
include dconf-editor.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc

apparmor
caps.drop all
machine-id
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
tracelog

disable-mnt
private-bin dconf-editor
private-cache
private-dev
private-etc alternatives,fonts
private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
