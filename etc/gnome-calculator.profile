# Firejail profile for gnome-calculator
# Description: GNOME desktop calculator
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gnome-calculator.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
# net none
netfilter
no3d
# nodbus - makes settings immutable
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin gnome-calculator
private-cache
private-dev
#private-lib gdk-pixbuf-2.*,gio,girepository-1.*,gvfs,libgconf-2.so.*,libgnutls.so.*,libproxy.so.*,librsvg-2.so.*,libxml2.so.*
private-tmp

# memory-deny-write-execute
