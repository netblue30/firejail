# Firejail profile for warzone2100
# Description: 3D real time strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include warzone2100.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.warzone2100-3.*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.warzone2100-3.1
mkdir ${HOME}/.warzone2100-3.2
allow  ${HOME}/.warzone2100-3.1
allow  ${HOME}/.warzone2100-3.2
allow  /usr/share/games
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
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
private-bin warzone2100
private-dev
private-tmp
