# Firejail profile for dconf
# Description: Configuration database system
# This file is overwritten after every install/update
# Persistent local customizations
include dconf.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${HOME}/.local/share/glib-2.0
# dconf paths are whitelisted by the following
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
noinput
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
x11 none

disable-mnt
private-bin dconf,gsettings
private-cache
private-dev
private-etc alternatives,dconf,ld.so.preload
private-lib
private-tmp

memory-deny-write-execute
