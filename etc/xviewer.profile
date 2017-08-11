# Firejail profile for xviewer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xviewer.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.Steam
noblacklist ~/.config/xviewer
noblacklist ~/.local/share/Trash
noblacklist ~/.steam

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

private-bin xviewer
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
notv
