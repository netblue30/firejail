# Firejail profile for easystroke
# Description: Control your desktop using mouse gestures
# This file is overwritten after every install/update
# Persistent local customizations
include easystroke.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.easystroke

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.easystroke
whitelist ${HOME}/.easystroke
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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
tracelog

disable-mnt
# breaks custom shell command functionality
#private-bin bash,easystroke,sh
private-cache
private-dev
private-etc
# breaks custom shell command functionality
#private-lib gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libgconf-2.so.*,librsvg-2.so.*
private-tmp

#dbus-user none
#dbus-system none

memory-deny-write-execute
restrict-namespaces
