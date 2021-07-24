# Firejail profile for teeworlds
# Description: Online multi-player platform 2D shooter
# This file is overwritten after every install/update
# Persistent local customizations
include teeworlds.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.teeworlds

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.teeworlds
allow  ${HOME}/.teeworlds
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
private-bin teeworlds
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
