# Firejail profile for gist
# Description: Potentially the best command line gister
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gist.local
# Persistent global definitions
include globals.local

deny  /tmp/.X11-unix
deny  ${RUNUSER}/wayland-*

nodeny  ${HOME}/.gist

# Allow ruby (blacklisted by disable-interpreters.inc)
include allow-ruby.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.gist
allow  ${HOME}/.gist
allow  ${DOWNLOADS}
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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-cache
private-dev
private-etc alternatives
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
