# Firejail profile for nslookup
# Description: DNS lookup utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include nslookup.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*
blacklist ${RUNUSER}

noblacklist ${PATH}/nslookup

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${HOME}/.nslookuprc
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
memory-deny-write-execute
netfilter
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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin bash,nslookup,sh
private-dev
private-tmp

memory-deny-write-execute
