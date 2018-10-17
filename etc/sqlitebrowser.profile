# Firejail profile for sqlitebrowser
# Description: GUI editor for SQLite databases
# This file is overwritten after every install/update
# Persistent local customizations
include sqlitebrowser.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/sqlitebrowser
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
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

private-bin sqlitebrowser
private-cache
private-dev
private-tmp

# memory-deny-write-execute - breaks on Arch
noexec ${HOME}
noexec /tmp
