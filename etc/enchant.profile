# Firejail profile for enchant
# Description: Wrapper for various spell checker engines
# This file is overwritten after every install/update
# Persistent local customizations
include enchant.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/enchant

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
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
tracelog

# private-bin enchant, enchant-*
private-cache
private-dev
private-etc alternatives
private-tmp

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
