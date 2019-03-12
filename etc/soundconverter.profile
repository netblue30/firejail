# Firejail profile for soundconverter
# Description: GNOME application to convert audio files into other formats
# This file is overwritten after every install/update
# Persistent local customizations
include soundconverter.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
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

private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
