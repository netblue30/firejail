# Firejail profile for keepass
# Description: An easy-to-use password manager
# This file is overwritten after every install/update
# Persistent local customizations
include keepass.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/*.kdb
nodeny  ${HOME}/*.kdbx
nodeny  ${HOME}/.config/KeePass
nodeny  ${HOME}/.config/keepass
nodeny  ${HOME}/.keepass
nodeny  ${HOME}/.local/share/KeePass
nodeny  ${HOME}/.local/share/keepass
nodeny  ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
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
protocol unix,inet,inet6,netlink
seccomp
shell none

private-cache
private-dev
private-tmp

