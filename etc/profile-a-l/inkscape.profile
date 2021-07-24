# Firejail profile for inkscape
# Description: Vector-based drawing program
# This file is overwritten after every install/update
# Persistent local customizations
include inkscape.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/inkscape
nodeny  ${HOME}/.config/inkscape
nodeny  ${HOME}/.inkscape
nodeny  ${DOCUMENTS}
nodeny  ${PICTURES}
# Allow exporting .xcf files
nodeny  ${HOME}/.config/GIMP
nodeny  ${HOME}/.gimp*


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

allow  /usr/share/inkscape
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
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

# private-bin inkscape,potrace,python* - problems on Debian stretch
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

# memory-deny-write-execute
