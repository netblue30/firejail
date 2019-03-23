# Firejail profile for megaglest
# Description: 3D multi-player real time strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include megaglest.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.megaglest

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.megaglest
whitelist ${HOME}/.megaglest
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
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin megaglest,megaglest_editor,megaglest_g3dviewer
private-cache
private-dev
private-tmp
