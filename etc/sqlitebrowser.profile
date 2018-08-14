# Firejail profile for sqlitebrowser
# Description: GUI editor for SQLite databases
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/sqlitebrowser.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/sqlitebrowser
noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

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
