# Firejail profile for transmission-remote
# Description: A remote control utility for transmission-daemon (CLI)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-remote.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/transmission
noblacklist ${HOME}/.config/transmission

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
machine-id
net none
nodbus
nodvd
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

# private-bin transmission-remote
private-dev
private-etc alternatives
private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
