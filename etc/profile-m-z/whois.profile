# Firejail profile for whois
# Description: Intelligent WHOIS client
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include whois.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
hostname whois
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private
private-bin bash,sh,whois
private-cache
private-dev
private-etc alternatives,hosts,jwhois.conf,resolv.conf,services,whois.conf
private-lib gconv
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
