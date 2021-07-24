# Firejail profile for w3m
# Description: WWW browsable pager with excellent tables/frames support
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include w3m.local
# Persistent global definitions
include globals.local

# Add the next lines to your w3m.local if you want to use w3m-img on a vconsole.
#ignore nogroups
#ignore private-dev
#ignore private-etc

nodeny  ${HOME}/.w3m

deny  /tmp/.X11-unix
deny  ${RUNUSER}/wayland-*

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.w3m
allow  /usr/share/w3m
allow  ${DOWNLOADS}
allow  ${HOME}/.w3m
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
private-bin perl,sh,w3m
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,mailcap,nsswitch.conf,pki,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
