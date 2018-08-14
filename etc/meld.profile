# Firejail profile for meld
# Description: Graphical tool to diff and merge files
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/meld.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/meld

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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

private-bin meld,python*
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
