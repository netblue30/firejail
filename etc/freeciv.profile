# Firejail profile for freeciv
# Description: A multi-player strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include freeciv.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.freeciv

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.freeciv
whitelist ${HOME}/.freeciv
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodbus
nodvd
nogroups
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
private-bin freeciv-gtk3,freeciv-mp-gtk3,freeciv-server,freeciv-manual
private-cache
private-dev
private-tmp
