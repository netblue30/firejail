# Firejail profile for x2goclient
# Description: Graphical client for X2Go remote desktop system
# This file is overwritten after every install/update
# Persistent local customizations
include x2goclient.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.x2go
nodeny  ${HOME}/.x2goclient

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
ipc-namespace
netfilter
#no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

#private-bin nxproxy,x2goclient
private-cache
private-dev
#private-etc alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-3.0,host.conf,hostname,hosts,machine-id,pki,pulse,resolv.conf,ssl,X11,xdg
#private-lib
private-opt none
private-srv none
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute
