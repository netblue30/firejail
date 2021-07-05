# Firejail profile for bzflag
# Description: 3D multi-player tank battle game
# This file is overwritten after every install/update
# Persistent local customizations
include bzflag.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.bzf

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.bzf
allow  ${HOME}/.bzf
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
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

disable-mnt
private-bin bzadmin,bzflag,bzflag-wrapper,bzfs
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
