# Firejail profile for netactview
# Description: A graphical network connections viewer similar in functionality to netstat
# This file is overwritten after every install/update
# Persistent local customizations
include netactview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.netactview

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkfile ${HOME}/.netactview
whitelist ${HOME}/.netactview
whitelist /usr/share/netactview
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
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
seccomp

disable-mnt
private-bin netactview,netactview_polkit
private-cache
private-dev
private-etc alternatives,fonts,ld.so.cache,ld.so.preload,resolv.conf
private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
