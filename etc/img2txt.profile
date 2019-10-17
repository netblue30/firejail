# Firejail profile for img2txt
# This file is overwritten after every install/update
# Persistent local customizations
include img2txt.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/imlib2
include whitelist-usr-share-common.inc

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
x11 none

# private-bin img2txt
private-cache
private-dev
private-tmp

memory-deny-write-execute
