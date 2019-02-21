# Firejail profile for gconf-editor
# Description: Graphical gconf registry editor
# This file is overwritten after every install/update
# Persistent local customizations
include gconf-editor.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gconf

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
# nodbus - DBUS is needed to commit changes to gconf
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
private-bin gconf-editor
private-cache
private-dev
private-etc alternatives,fonts
private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
