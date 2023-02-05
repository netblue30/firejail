# Firejail profile for eo-common
# Description: Common profile for Eye of GNOME/MATE graphics viewer program
# This file is overwritten after every install/update
# Persistent local customizations
include eo-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.steam

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-write-mnt.inc

include whitelist-runuser-common.inc
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
protocol unix,netlink
seccomp
seccomp.block-secondary
tracelog

private-cache
private-dev
private-etc @x11
private-lib eog,eom,gdk-pixbuf-2.*,gio,girepository-1.*,gvfs,libgconf-2.so.*
private-tmp

restrict-namespaces
