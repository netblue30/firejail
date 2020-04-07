# Firejail profile for Newsboat
# Description: RSS program
# This file is overwritten after every install/update
# Persistent local customizations
include newsboat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.newsboat

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.newsboat
whitelist ${HOME}/.newsboat
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol inet,inet6
seccomp
shell none

disable-mnt
private-bin newsboat
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,pki,resolv.conf,ssl,terminfo
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
