# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/sqlitebrowser.local

# Firejail profile for SQLiteBrowser
noblacklist ${HOME}/.config/sqlitebrowser

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
nogroups
nonewprivs
noroot
nosound
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
