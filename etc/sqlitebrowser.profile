# Firejail profile for sqlitebrowser
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/sqlitebrowser.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/sqlitebrowser

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
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
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
