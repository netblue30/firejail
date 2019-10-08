# Firejail profile for dconf-editor
# Description: dconf configuration editor
# This file is overwritten after every install/update
# Persistent local customizations
include dconf-editor.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${HOME}/.local/share/glib-2.0
include whitelist-common.inc
include whitelist-usr-share-common.inc

apparmor
caps.drop all
# net none - breaks application on older versions
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
private-etc alternatives,dconf,fonts,gtk-3.0,machine-id
private-lib
private-tmp
