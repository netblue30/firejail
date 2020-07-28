# Firejail profile for dia
# Description: Diagram editor
# This file is overwritten after every install/update
# Persistent local customizations
include dia.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.dia
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include allow-python2.inc
include allow-python3.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
#private-bin dia
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
