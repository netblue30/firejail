# Firejail profile for inkscape
# Description: Vector-based drawing program
# This file is overwritten after every install/update
# Persistent local customizations
include inkscape.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/inkscape
noblacklist ${HOME}/.config/inkscape
noblacklist ${HOME}/.inkscape
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

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

include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
nodbus
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
tracelog

# private-bin inkscape,potrace,python* - problems on Debian stretch
private-cache
private-dev
private-tmp

# memory-deny-write-execute
