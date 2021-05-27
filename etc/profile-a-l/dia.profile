# Firejail profile for dia
# Description: Diagram editor
# This file is overwritten after every install/update
# Persistent local customizations
include dia.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.dia
noblacklist ${DOCUMENTS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

#mkdir ${HOME}/.dia
#whitelist ${HOME}/.dia
#whitelist ${DOCUMENTS}
#include whitelist-common.inc
whitelist /usr/share/dia
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
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
tracelog

disable-mnt
#private-bin dia
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
