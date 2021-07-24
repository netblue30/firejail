# Firejail profile for lximage-qt
# Description: Image viewer for LXQt
# This file is overwritten after every install/update
# Persistent local customizations
include lximage-qt.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/lximage-qt

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
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
protocol unix
seccomp
shell none

private-cache
private-dev
private-tmp

