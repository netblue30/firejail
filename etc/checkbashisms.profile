# Firejail profile for checkbashisms
# Description: Lint tool for shell scripts
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include checkbashisms.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

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
no3d
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
x11 none

private-cache
private-dev
private-lib perl*
private-tmp

memory-deny-write-execute
